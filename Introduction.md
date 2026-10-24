# 01 — Introduction to Terraform
## What is Terraform?

Terraform is a tool for Infrastructure as Code (IaC). Instead of manually creating cloud resources in a console, you define the needed infrastructure in configuration files. Terraform analyzes the configuration to its state and to the real infrastructure and then offers adjustments.
For example, a configuration might define an AWS EC2 instance, a network, or an S3 bucket.

## Why use Terraform?

  - Reusability: can be reused for similar infrastructures.
  - Version control: review infrastructure changes in Git.
  - Automation: integrate infrastructure changes into scripts and CI/CD.
  - Planning: preview proposed changes before applying them.
  - Reuse: develop modules for typical patterns in infrastructure.

You describe the desired result rather than writing every API call in order.
```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


provider "aws" {
  region = "ap-south-1"
}


resource "aws_s3_bucket" "learning" {
  bucket_prefix = "terraform-learning-"
}
```

This example creates an S3 bucket with a generated unique suffix. It requires AWS credentials and can create billable resources. Destroy it when finished.

## Install and check Terraform

Install Terraform using the instructions mentioned in official documentation for your operating system, then run:
``
terraform version
``

For AWS examples, install the AWS CLI and configure credentials using a supported method such as an AWS profile or IAM role:
``aws --version
aws sts get-caller-identity``

Do not place access keys directly in .tf files.

## Core commands
  - **terraform init**      # Install providers and initialize the directory
  - **terraform fmt**        # Format Terraform files
  - **terraform validate**   # Check configuration syntax and consistency
  - **terraform plan**       # Preview proposed changes
  - **terraform apply**      # Apply the plan after confirmation
  - **terraform destroy**    # Remove resources managed by this configuration

## Important terms

  - Provider: plugin that communicates with a platform such as AWS.
  - Resource: infrastructure Terraform manages.
  - Data source: information Terraform reads from existing infrastructure.
  - State: Terraform's record of managed resources and their attributes.
  - Module: a reusable collection of Terraform configuration.
  - Plan: proposed actions Terraform calculates before applying.

## Practice
Install Terraform.
Run terraform version.
Create a directory for one example.
Run terraform init, terraform fmt, and terraform validate.
Before applying any cloud example, read the plan and understand the cost and cleanup steps.
