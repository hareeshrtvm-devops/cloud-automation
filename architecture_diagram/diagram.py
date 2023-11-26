# diagram.py
from diagrams import Diagram, Cluster
from diagrams.aws.network import ELB, Route53, VPC
from diagrams.aws.compute import EC2, ECS, AutoScaling
from diagrams.generic.network import Firewall
from diagrams.aws.management import Cloudwatch
from diagrams.aws.general import Users

with Diagram("Assignment-project-HA-001", show=False):
    App_Users = Users("app users")
    with Cluster("AWS"):
        dns = Route53("DNS")
        lb = ELB("ELB")
        waf = Firewall("WAF")

        with Cluster("VPC"):
            with Cluster("Private subnet cluster"):
                with Cluster("ECS cluster - Availability Zone-1"):
                    workers = [ECS("Container-1"),
                              ECS("Container-2")]
                autoscaling = AutoScaling("AutoScaling Group")
                with Cluster("ECS cluster - Availability Zone-2"):
                    workers_1 = [ECS("Container-1"),
                                ECS("Container-2")]
                workers >> Cloudwatch("Monitoring") << workers_1
    private_subnet = Cluster("Private subnet cluster")
    App_Users >> dns >> waf >> lb >> workers >> autoscaling << workers_1
#    lb >> workers_1
