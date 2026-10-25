# WordPress Deployment on AWS Using Terraform

![AWS](https://img.shields.io/badge/Cloud-AWS-orange)
![Terraform](https://img.shields.io/badge/IaC-Terraform-purple)
![WordPress](https://img.shields.io/badge/Application-WordPress-blue)
![Linux](https://img.shields.io/badge/OS-Ubuntu-E95420)

## 1. Project Overview

This project demonstrates the deployment of a WordPress website on Amazon Web Services (AWS) using Terraform as the Infrastructure as Code (IaC) tool.

The infrastructure is designed with a frontend and backend architecture. Two EC2 instances host the WordPress application, while a separate EC2 instance in a private subnet hosts the MySQL database.

Terraform provisions the required networking and compute resources, while Bash user data scripts automate the installation and initial configuration of the application and database components.

### Project Objectives

- Provision AWS infrastructure using Terraform.
- Create a custom VPC with public and private subnets.
- Configure Internet Gateway, NAT Gateway, and route tables.
- Deploy WordPress on Apache and PHP.
- Configure MySQL on a private EC2 instance.
- Automate software installation using EC2 user data.
- Configure security groups for frontend-to-backend communication.
- Validate website access and database connectivity.

## 2. Architecture

### Architecture Overview

The infrastructure contains the following components:

- One custom VPC.
- Two public subnets in separate Availability Zones.
- One private subnet for the database server.
- Two frontend EC2 instances.
- One backend EC2 instance running MySQL.
- One Internet Gateway.
- One NAT Gateway.
- Public and private route tables.
- Frontend and backend security groups.

### Architecture Diagram

Add your architecture diagram here.

![AWS WordPress Architecture]()

*Figure 1: AWS WordPress deployment architecture.*

**Traffic flow:**

1. Users access the WordPress frontend through the public IP address of a frontend EC2 instance.
2. Apache serves the WordPress application using PHP.
3. WordPress connects to MySQL on the private EC2 instance using its private IP address.
4. The backend instance uses the NAT Gateway for outbound internet access when required.

Note: An Application Load Balancer is not included in the current Terraform configuration. Users access the frontend instances directly.

## 3. Technologies Used

| Technology | Purpose |
|---|---|
| AWS VPC | Isolated network environment |
| Amazon EC2 | Hosts WordPress and MySQL |
| Public and private subnets | Network segmentation |
| Internet Gateway | Internet routing for public subnets |
| NAT Gateway | Outbound internet access from the private subnet |
| Security Groups | Instance-level traffic filtering |
| Terraform | Infrastructure provisioning |
| Bash | Automated instance configuration |
| Apache | Web server |
| PHP | WordPress runtime |
| WordPress | Website application |
| MySQL | Database |
| Ubuntu | Operating system |

## 4. Repository Structure

```text
terraform-aws-wordpress-deployment/
├── screenshots/
├── backend.tf
├── backend_user-data.sh
├── frontend.tf
├── frontend_user-data.sh
├── main.tf
├── provider.tf
├── security_group.tf
├── variable.tf
├── .gitignore
└── README.md
```

The local `terraform.tfvars` file supplies deployment-specific values. Keep it out of the public repository if it contains environment-specific or sensitive configuration.

## 5. Prerequisites

Before deploying the project, ensure that you have:

- An AWS account with permission to create the required EC2 and networking resources.
- Terraform installed on your local machine.
- AWS CLI installed and configured.
- An EC2 key pair available in the selected AWS Region.
- An Ubuntu AMI compatible with your configuration and selected Region.
- Basic knowledge of Linux commands, SSH, AWS networking, and Terraform.

Verify the installations:

```bash
terraform -version
aws --version
```

Configure AWS credentials using an appropriate method, such as an AWS CLI profile or environment variables.

```bash
aws configure
aws sts get-caller-identity
```

Do not commit AWS credentials or private key files to GitHub.

## 6. Configure the Project

### Step 1: Clone the Repository

Replace the URL below with your actual GitHub repository URL.

```bash
git clone <YOUR_GITHUB_REPOSITORY_URL>
cd terraform-aws-wordpress-deployment
```

### Step 2: Configure Terraform Variables

Create a local `terraform.tfvars` file using the variables declared in `variable.tf`.

Example configuration:

```hcl
region               = "us-east-1"
vpc_cidr             = "10.0.0.0/16"
project              = "WordPress"
owner                = "ProjectOwner"
public_subnet_cidr_1 = "10.0.1.0/24"
public_subnet_cidr_2 = "10.0.2.0/24"
private_subnet_cidr  = "10.0.3.0/24"
ami                  = "<VALID_UBUNTU_AMI_ID>"
instance_type        = "t3.micro"
key_name             = "<YOUR_EC2_KEY_PAIR_NAME>"
```

Replace the example owner, AMI ID, and key pair name with appropriate values for your deployment.

The AMI must exist in the selected AWS Region and must be compatible with the installation scripts.

**Screenshot 2 — Terraform configuration**

![Terraform variables](screenshots/terraform-variables.png)

*Figure 2: Terraform deployment variables configured locally. Hide sensitive information before capturing the screenshot.*

## 7. Deployment Steps

### Step 1: Initialize Terraform

Run the following command from the project directory:

```bash
terraform init
```

Terraform downloads the required provider plugins and initializes the working directory.

Expected result: Terraform initialization completes successfully.

**Screenshot 3 — Terraform initialization**

![Terraform init](screenshots/05-terraform-init.png)

### Step 2: Format and Validate the Configuration

Format the Terraform files:

```bash
terraform fmt -recursive
```

Validate the configuration:

```bash
terraform validate
```

`terraform validate` checks the configuration's syntax and internal consistency. It does not prove that the AWS resources can be created successfully.

**Screenshot 4 — Terraform validation**

![Terraform validation](screenshots/terraform-validate.png)

### Step 3: Review the Execution Plan

Run:

```bash
terraform plan
```

Review the resources Terraform proposes to create, modify, or destroy.

Check that the intended VPC, subnets, route tables, gateways, security groups, and EC2 instances are included.

Do not proceed if the plan contains unexpected destructive changes.

**Screenshot 5 — Terraform plan**

![Terraform plan](screenshots/06-terraform-plan.png)

### Step 4: Provision the AWS Infrastructure

Run:

```bash
terraform apply
```

Review the plan and confirm the operation when prompted.

Terraform will create the resources described in the configuration, subject to AWS permissions, provider support, service quotas, and resource availability.

**Important:** NAT Gateways and public IPv4 addresses can incur AWS charges. Review the estimated costs before proceeding.

**Screenshot 6 — Terraform apply**

![Terraform apply](screenshots/07-terraform-apply.png)

### Step 5: Verify the VPC and Subnets

Open the AWS Management Console.

Navigate to:

**VPC → Your VPCs**

Verify that the custom VPC exists and has the expected CIDR block.

Then navigate to:

**VPC → Subnets**

Confirm that the two public subnets and one private subnet have the expected CIDR blocks and Availability Zones.

**Screenshot 7 — VPC and subnet configuration**

![AWS VPC and subnets](screenshots/01-aws-vpc.png)

### Step 6: Verify Gateways and Route Tables

Navigate to the VPC console and inspect the Internet Gateway, NAT Gateway, route tables, and subnet associations.

Verify that:

- The public route table has a default route through the Internet Gateway.
- The private route table has a default route through the NAT Gateway.
- The public subnets are associated with the public route table.
- The private subnet is associated with the private route table.
- The NAT Gateway is available and correctly configured.

**Screenshot 8 — Route tables**

![AWS route tables](screenshots/03-route-tables.png)

### Step 7: Verify the EC2 Instances

Navigate to:

**EC2 → Instances**

Confirm that the frontend instances and private database instance have been created.

Check their instance states, subnet assignments, private IP addresses, and public IP addresses where applicable.

Wait for instance initialization and the user data scripts to finish.

**Screenshot 9 — EC2 instances**

![EC2 instances](screenshots/08-ec2-instances.png)

### Step 8: Verify Security Groups

Navigate to:

**EC2 → Security Groups**

Inspect the frontend and backend security groups.

The intended traffic rules are:

- Frontend: HTTP on TCP port 80 and SSH on TCP port 22.
- Backend: MySQL on TCP port 3306, with access from the frontend security group.
- Backend SSH: permitted from the frontend security group.

The configured egress rules allow outbound traffic.

**Security note:** The current frontend SSH rule allows access from `0.0.0.0/0`. This is suitable only for a controlled lab configuration with appropriate precautions, not a recommended production setting. Restrict SSH to a trusted IP range or use AWS Systems Manager where appropriate.

**Screenshot 10 — Security groups**

![Security groups](screenshots/04-security-groups.png)

## 8. Automated Instance Configuration

### Backend User Data

The `backend_user-data.sh` script automates the initial setup of the database server.

Its responsibilities include:

1. Updating package repositories.
2. Installing MySQL Server.
3. Enabling and starting the MySQL service.
4. Configuring MySQL to listen for remote connections.
5. Creating the WordPress database and database user.
6. Granting database privileges and flushing privileges.

The MySQL service runs on the private EC2 instance.

### Frontend User Data

The `frontend_user-data.sh` script automates the WordPress frontend setup.

Its responsibilities include:

1. Installing Apache, PHP, MySQL client utilities, and PHP extensions.
2. Starting and enabling Apache.
3. Downloading and extracting WordPress.
4. Creating the WordPress configuration file.
5. Configuring the database connection.
6. Setting ownership and permissions for website files.
7. Restarting Apache.
8. Checking whether the database is reachable.

The frontend configuration receives the private database IP address from Terraform.

## 9. Access the WordPress Website

After the EC2 instances have initialized, open the EC2 console and select a frontend instance.

Copy its public IPv4 address.

Open a browser and visit:

```text
http://<FRONTEND_PUBLIC_IP>
```

If the database is reachable and the application has initialized correctly, the WordPress setup page should appear.

Follow the on-screen WordPress setup process to configure the website.

**Screenshot 11 — WordPress setup page**

![WordPress setup](screenshots/10-wordpress-setup.png)

After completing the setup, capture a screenshot of the working website.

**Screenshot 12 — WordPress website**

![WordPress website](screenshots/09-wordpress-website.png)

## 10. Validation Checklist

Use this checklist to document the results of your deployment.

- [ ] Terraform initialization completed successfully.
- [ ] Terraform validation completed successfully.
- [ ] Terraform applied the intended infrastructure.
- [ ] VPC and subnet configuration verified.
- [ ] Internet Gateway and NAT Gateway verified.
- [ ] Route tables and subnet associations verified.
- [ ] Frontend and backend EC2 instances are running.
- [ ] Security group rules inspected.
- [ ] Apache service is running on the frontend.
- [ ] MySQL service is running on the backend.
- [ ] WordPress can connect to the MySQL database.
- [ ] WordPress setup page is accessible through a frontend public IP.

Only mark a check as complete after you have verified it.

## 11. Troubleshooting

### Problem 1: Terraform Initialization Fails

Possible causes:

- Incorrect provider configuration.
- Internet connectivity issues.
- Provider version or dependency download problems.

Useful commands:

```bash
terraform init
terraform validate
```

### Problem 2: EC2 Instance Is Running but the Website Does Not Open

Check:

- Whether the frontend instance has a public IP address.
- Whether the subnet route table has an Internet Gateway route.
- Whether the security group permits inbound HTTP traffic on port 80.
- Whether Apache is running.
- Whether the user data script completed successfully.

Useful commands on the frontend instance:

```bash
sudo systemctl status apache2
sudo tail -n 100 /var/log/cloud-init-output.log
sudo tail -n 100 /var/log/apache2/error.log
```

### Problem 3: WordPress Cannot Connect to MySQL

Check:

- Whether MySQL is running on the backend instance.
- Whether the database instance has the expected private IP.
- Whether the backend security group allows TCP port 3306 from the frontend security group.
- Whether MySQL is listening on the correct network interface.
- Whether the database, username, password, and allowed database-user host are correct.

Useful commands on the backend instance:

```bash
sudo systemctl status mysql
sudo ss -lntp | grep 3306
sudo tail -n 100 /var/log/cloud-init-output.log
```

### Problem 4: User Data Did Not Complete Successfully

Check the cloud-init logs on the affected EC2 instance:

```bash
sudo cat /var/log/cloud-init-output.log
sudo cloud-init status --long
```

Review the errors and address the underlying cause before retrying the deployment.

## 12. Infrastructure Cleanup

When you have finished testing, destroy the resources if you no longer need them.

From the project directory, run:

```bash
terraform plan -destroy
terraform destroy
```

Review the resources that will be deleted and confirm the operation.

**Warning:** This deletes Terraform-managed infrastructure and can permanently remove application data stored on those resources. Back up anything you need first.

Also check the AWS console afterward to verify that billable resources have been removed.

## 13. Future Enhancements

Potential improvements to explore in future iterations include:

- Application Load Balancer with health checks.
- Auto Scaling Group for frontend instances.
- Bastion Host or AWS Systems Manager for administrative access.
- AWS Secrets Manager for database credentials.
- Amazon RDS for managed database hosting.
- HTTPS using AWS Certificate Manager.
- Amazon CloudWatch monitoring and logging.
- Remote Terraform state management using Amazon S3 and supported state locking.
- CI/CD integration for automated infrastructure deployment.
- Shared WordPress media storage and a strategy for consistent application files across frontend instances.

These enhancements are not represented as implemented features in the current configuration.

## 14. Skills Demonstrated

- Terraform and Infrastructure as Code.
- AWS EC2 and VPC networking.
- Public and private subnet design.
- Route tables, Internet Gateway, and NAT Gateway.
- AWS security groups.
- Bash scripting and EC2 user data.
- Linux service administration.
- Apache, PHP, WordPress, and MySQL configuration.
- Application-to-database connectivity.
- Infrastructure troubleshooting.

## 15. Author

**DevOps Learner | AWS | Terraform | Linux | Infrastructure Automation**

This project is part of my hands-on learning journey in cloud computing and DevOps engineering.

Feedback and suggestions for improvement are welcome.
