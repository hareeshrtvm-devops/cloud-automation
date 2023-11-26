###ALB
resource "aws_lb" "my_alb" {
  name               = "${var.base_name}-ecs-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ECS-ALB-SG.id]
  subnets            = ["${aws_subnet.public-subnet-1.id}", "${aws_subnet.public-subnet-2.id}", "${aws_subnet.public-subnet-3.id}" ]
}
###TG
resource "aws_lb_target_group" "ip_target_group" {
  name               = "${var.base_name}-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  target_type = "ip"
  health_check {
    path               = "/"
    port               = "traffic-port"
    protocol           = "HTTP"
    interval           = 30
    timeout            = 5
    healthy_threshold  = 2
    unhealthy_threshold = 2
  }
}
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ip_target_group.arn
  }
}
resource "aws_ecs_cluster" "ecs-cluster" {
  name = "${var.base_name}-ecs-cluster"
}
data "aws_ecs_task_definition" "my_task_definition" {
    task_definition = aws_ecs_task_definition.my_task_definition.family
}
data "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.base_name}-task-execution-role"
  depends_on = [aws_iam_role.task_execution_role]
}
resource "aws_ecs_cluster_capacity_providers" "ecs-cluster-capacity_provider" {
    cluster_name = aws_ecs_cluster.ecs-cluster.name
    capacity_providers = ["FARGATE"]
    default_capacity_provider_strategy {
      base                 =    1
      weight               =    100
      capacity_provider    = "FARGATE"
    }
}
###task def
resource "aws_ecs_task_definition" "my_task_definition" {
  family                   = "${var.base_name}-ecs"
  execution_role_arn        = data.aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      "name": "${var.base_name}-ecs-container",
      "image": "nginxdemos/hello:latest",
      "cpu": 0,
      "portMappings": [
        {
          "name": "${var.base_name}-ecs-container-80-tcp",
          "containerPort": 80,
          "hostPort": 80,
          "protocol": "tcp",
          "appProtocol": "http"
        }
      ],
      "essential": true,
      "environment": [],
      "environmentFiles": [],
      "mountPoints": [],
      "volumesFrom": [],
      "ulimits": [],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-create-group": "true",
          "awslogs-group": "/ecs/${var.base_name}-ecs"
          "awslogs-region": "us-east-1",
          "awslogs-stream-prefix": "ecs"
        }
      }
    }
  ])
}
# Create an ECS service
resource "aws_ecs_service" "ecs-svc" {
  name            = "${var.base_name}-ecs-svc"
  cluster         = aws_ecs_cluster.ecs-cluster.arn
  task_definition = aws_ecs_task_definition.my_task_definition.arn
  desired_count   = 2
  launch_type = "FARGATE"

  network_configuration {
    subnets         = ["${aws_subnet.private-subnet-1.id}", "${aws_subnet.private-subnet-2.id}", "${aws_subnet.private-subnet-3.id}"]
    security_groups = [aws_security_group.ecs_service_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ip_target_group.arn
    container_name   = "${var.base_name}-ecs-container"
    container_port   = 80
  }
}
###WAF
resource "aws_wafv2_web_acl" "web_acl" {
  name        = "${var.base_name}-web-acl"
  scope       = "REGIONAL"
  description = "Web ACL"
  
  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name               = "myWebAclMetric"
    sampled_requests_enabled  = true
  }

  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 1
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name               = "myWebAclMetric"
      sampled_requests_enabled  = true
    }
  }

  rule {
    name     = "AWSManagedRulesAnonymousIpList"
    priority = 2
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAnonymousIpList"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name               = "myWebAclMetric"
      sampled_requests_enabled  = true
    }
  }

  rule {
    name     = "AWSManagedRulesKnownBadInputsRuleSet"
    priority = 3
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name               = "myWebAclMetric"
      sampled_requests_enabled  = true
    }
  }
}

resource "aws_wafv2_web_acl_association" "alb_web_acl_association" {
  resource_arn = aws_lb.my_alb.arn
  web_acl_arn  = aws_wafv2_web_acl.web_acl.arn
}

