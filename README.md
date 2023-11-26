# cloud-automation

Project Overview: 
	Deploy a HA web app using Terraform
 

Repository Contents:
	README.md
	LICENSE
	architecture_diagram		
		It includes an architecture diagram of the project and the Python script which can be used to create the diagram. 
	cloud-web-app-terraform-project
		It includes the Terraform scripts to create all the required services in the AWS cloud mentioned in the architecture diagram 


Getting Started:
	clone the repository and follow the instructions


Prerequisites:
	An AWS account with a service user access (IAM key) with required privileges to create the cloud services mentioned in the Architecture.
	Terraform must be installed and running


Steps:
	Clone the repository
	cd cloned-repo directory
	terraform init
	terraform plan
		Note: at this point, it will ask you to enter the AWS ACCESS KEY ID and SECRET KEY. Once you enter the access key and SECRET ID, It will ask you for a base_name.
  
	What is a base_name: A common name that you have decided to give to the project. Example: assignment-project-01.
	Where it will be used: It will be used as the base resource name for all the resources that will be created using the script.
	Why we need a base name: To provide a standard naming convention for all the resources created.
	Benefits: Easy to understand the resources that are created for each environment/Project.

 	Once validated the steps that the script is going execute in your cloud, 

	terraform apply:
	Provide the same ACCESS KEY ID, SECRET KEY, and the base name.
	
	terraform destroy:
		To terminate the services created in the AWS account by the terraform script.
