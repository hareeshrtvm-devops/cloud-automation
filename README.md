# Cloud Automation: HA Web App Deployment with Terraform

## Project Overview

Deploy a highly available web app using Terraform.

## Repository Contents

- **README.md**: Documentation for getting started, prerequisites, and steps.
- **LICENSE**: License information.
- **architecture_diagram**: Contains an architecture diagram of the project and a Python script to create the diagram.
- **cloud-web-app-terraform-project**: Terraform scripts to create AWS cloud services mentioned in the architecture diagram.

## Getting Started

1. Clone the repository.
2. Follow the instructions below.

## Prerequisites

- AWS account with a service user access (IAM key) and required privileges.
- Installed and configured Terraform.

## Steps

1. Clone the repository.
2. Navigate to the cloned repository directory.
3. Run `terraform init`.
4. Run `terraform plan`.
   - Enter AWS ACCESS KEY ID and SECRET KEY.
   - Enter a `base_name` when prompted.
     - `base_name`: A common name for the project (e.g., assignment-project-01).
   - Review the plan and proceed if satisfied.
5. Run `terraform apply`.
   - Provide ACCESS KEY ID, SECRET KEY, and the `base_name`.
6. To destroy created services, run `terraform destroy`.

### Note

- `base_name`: Common name for project resources, used for standard naming convention.
- Benefits: Provides clarity and standardization for created resources.

Feel free to reach out for assistance or more information.
