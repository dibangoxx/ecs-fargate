# ecs-fargate

ECS Fargate Deployment
This repository contains the necessary infrastructure-as-code (IaC) scripts to deploy a containerized application using Amazon Elastic Container Service (ECS) with Fargate launch type. The deployment is fully automated and can be easily customized to suit your application's specific requirements.

Prerequisites
Before getting started, make sure you have the following prerequisites in place:

AWS Account: You'll need an AWS account to deploy the ECS infrastructure.
AWS CLI: Install and configure the AWS CLI on your local machine.
Terraform: Install Terraform on your local machine.
Deployment Steps
To deploy the ECS Fargate infrastructure, follow these steps:

Clone this repository to your local machine.
Navigate to the project directory.
Initialize the Terraform backend by running terraform init.
Modify the variables.tf file to set the desired configuration parameters for your deployment, such as VPC details, container image, CPU and memory allocation, etc.
Review and customize the other Terraform files (ecs.tf, vpc.tf, alb.tf, etc.) based on your specific requirements.
Run terraform plan to preview the infrastructure changes that will be applied.
Run terraform apply to deploy the ECS Fargate infrastructure.
Wait for the deployment to complete. Once finished, the output will display the URL of the load balancer associated with your ECS service.
Customization
This deployment can be customized to fit your application's needs. Here are a few areas you may consider customizing:

Container Image: Update the app_image variable in variables.tf to point to your desired container image.
CPU and Memory Allocation: Adjust the fargate_cpu and fargate_memory variables in variables.tf to allocate the appropriate CPU and memory resources for your application.
Networking: Modify the VPC configuration, subnet configuration, security groups, and load balancer settings in the respective Terraform files (vpc.tf, alb.tf, etc.) to match your networking requirements.
Auto Scaling: Implement auto scaling policies and rules in the autoscaling.tf file to dynamically scale your ECS tasks based on metrics such as CPU utilization or request count.
Clean Up
To clean up and destroy the deployed infrastructure, run the following command: "terraform destroy --auto-approve