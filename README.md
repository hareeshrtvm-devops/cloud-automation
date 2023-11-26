# cloud-automation
Project Overview: 
	Deploy a HA web app using terraform

Repository Contents:
	README.md
	LICENSE
	architecture_diagram		
		It inlcudes, Architecture diagram of the project and the python script which can be used to create the diagram. 
	cloud-web-app-terraform-project
		It includes the Terraform scripts to create all the required services in AWS cloud mentioned in the architecture diagram 

Getting Started:
	clone the repository and follow the instructions

Prerequisites:
	An AWS account with a service user access (IAM key) with required privileges to create the cloud services mentioned in the Architecture.
	Terraform must be installed and running

Steps:
	Clone the reporsitory
	cd cloned-repo directory
	terraform init
	terraform plan
		Note: at this point it will ask you to enter the AWS ACCESS KEY and ACCESS KEY ID. Once you enter the access key and ID, It will ask you for a base_name.
	What is a base_name: A common name that you have decided to give to the project. Example: assignment-project-01.
	Where it will be sued: It will be used as teh base resource name for all the resources will be created using the scipt.
	Why we need base name: To provide a standard naming convention for all the resources been created.
	Benifits: Easy to understand the resoures that created for ech environment/Projects.

 	Once validated the steps that the scriupt is going execute it in your cloud, 

	terraform apply:
	Provide the same ACCESS KEY ID, SECRET KEY and the base name.
	
	terraform destroy:
		To terminate the services created in AWS account by the terraform script.
