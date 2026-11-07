# 02 — HCL Basics

## 1. What Is HCL?

HCL stands for **HashiCorp Configuration Language**.

It is the language used to write Terraform configuration files.

In simple words, HCL allows us to tell Terraform:
- What infrastructure we want to create.
- Which cloud provider we want to use.
- What configurations our resources should have.
- Which values should be used in our infrastructure.

For example, if we want to create an AWS EC2 instance, we write the required configuration in HCL, and Terraform uses that configuration to manage the resource.

HCL is designed to be human-readable, which makes it easier to understand and maintain infrastructure configurations.

## 2. Basic HCL Syntax

Let's understand the basic structure of an HCL configuration.

```hcl
# This is a comment

variable "environment" {
  description = "Name of the environment"
  type        = string
  default     = "dev"
}

locals {
  project_name = "terraform-learning"
  full_name    = "${local.project_name}-${var.environment}"
}

output "resource_name_prefix" {
  value = local.full_name
}
```

### Understanding the Example

**1. Comment**

```hcl
# This is a comment
```

Comments are used to explain what a particular line or section of code does.

Terraform ignores comments when processing the configuration.

**2. Variable Block**

```hcl
variable "environment" {
  description = "Name of the environment"
  type        = string
  default     = "dev"
}
```

A variable allows us to provide input values to our Terraform configuration.

Here:
- `environment` is the variable name.
- `description` explains the purpose of the variable.
- `type` defines the kind of value it accepts.
- `default` provides a value when no other value is supplied.

**3. Locals Block**

```hcl
locals {
  project_name = "terraform-learning"
  full_name    = "${local.project_name}-${var.environment}"
}
```

Locals are used to store values that we want to reuse inside our Terraform configuration.

Here:
- `project_name` stores the project name.
- `full_name` combines the project name with the environment variable.

If the environment is `dev`, the result will be:

```text
terraform-learning-dev
```

**4. Output Block**

```hcl
output "resource_name_prefix" {
  value = local.full_name
}
```

Output blocks are used to display useful information after Terraform completes an operation.

In this example, Terraform displays the value stored in `local.full_name`.

## 3. Understanding Blocks and Arguments

HCL configuration is written using blocks and arguments.

### What Is a Block?

A block is a section of Terraform configuration that groups related settings together.

For example:

```hcl
resource "aws_s3_bucket" "example" {
  bucket_prefix = "hcl-demo-"
}
```

Let's break it down:

| Part | Meaning |
|---|---|
| `resource` | Block type |
| `aws_s3_bucket` | Resource type |
| `example` | Local resource name |
| `bucket_prefix` | Argument |
| `"hcl-demo-"` | Value assigned to the argument |

### What Is an Argument?

An argument assigns a value to a particular setting inside a block.

For example:

```hcl
bucket_prefix = "hcl-demo-"
```

Here:
- `bucket_prefix` is the argument name.
- `"hcl-demo-"` is the value assigned to it.

**Remember:** A block defines a section of configuration, while arguments define the settings inside that block.

### Common Terraform Block Types

| Block | Purpose |
|---|---|
| `variable` | Defines input variables |
| `locals` | Stores reusable local values |
| `output` | Displays useful information |
| `provider` | Configures a cloud or service provider |
| `resource` | Defines infrastructure resources |
| `data` | Reads information about existing resources |

## 4. Common HCL Data Types

Terraform supports different data types to store different kinds of values.

Let's understand the commonly used types.

### A. String

A string is used to store text.

```hcl
variable "environment" {
  type    = string
  default = "dev"
}
```

Example values: `"dev"`, `"production"`, `"Bangalore"`.

### B. Number

A number is used to store numeric values.

```hcl
variable "instance_count" {
  type    = number
  default = 2
}
```

Example values: `1`, `2`, `10`, `100`.

### C. Bool

A Boolean value represents either `true` or `false`.

```hcl
variable "enabled" {
  type    = bool
  default = true
}
```

Example values: `true` and `false`.

### D. List

A list stores multiple values in a specific order.

```hcl
variable "allowed_ports" {
  type    = list(number)
  default = [22, 80, 443]
}
```

Here, we are storing three port numbers in a list.

### E. Set

A set stores unique values. It does not preserve a meaningful element order.

```hcl
variable "allowed_ports" {
  type    = set(number)
  default = [22, 80, 443]
}
```

Sets are useful when duplicate values are not required.

### F. Map

A map stores values using key-value pairs.

```hcl
variable "tags" {
  type = map(string)

  default = {
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}
```

Here:
- `Environment` is a key.
- `"dev"` is its value.
- `ManagedBy` is another key.
- `"Terraform"` is its value.

### G. Object

An object stores multiple named attributes, and each attribute can have its own data type.

```hcl
variable "server" {
  type = object({
    name          = string
    instance_type = string
    volume_size   = number
  })

  default = {
    name          = "web-server"
    instance_type = "t3.micro"
    volume_size   = 20
  }
}
```

### H. Tuple

A tuple stores multiple values in a specific order, and each position can have a different data type.

```hcl
variable "server_details" {
  type    = tuple([string, number, bool])
  default = ["web-server", 20, true]
}
```

### Quick Data Type Revision

| Data Type | What It Stores | Example |
|---|---|---|
| `string` | Text | `"dev"` |
| `number` | Numeric values | `10` |
| `bool` | True or false | `true` |
| `list(T)` | Ordered collection of similar values | `[22, 80, 443]` |
| `set(T)` | Collection of unique values | `[22, 80, 443]` |
| `map(T)` | Key-value pairs | `{Environment = "dev"}` |
| `object({...})` | Named attributes with defined types | `{name = "server"}` |
| `tuple([...])` | Ordered values with defined types at each position | `["server", 20, true]` |

## 5. Understanding Expressions and References

Expressions allow us to work with values, combine them, and reuse information in Terraform.

One important feature of HCL is that we can reference variables and local values instead of repeatedly writing the same information.

### Example

```hcl
variable "environment" {
  type    = string
  default = "dev"
}

locals {
  bucket_prefix = "my-app-${var.environment}-"
}

output "prefix" {
  value = local.bucket_prefix
}
```

### Understanding the References

**1. Variable Reference**

```hcl
var.environment
```

This is used to access the value of an input variable.

Here, it returns:

```text
dev
```

**2. Local Value Reference**

```hcl
local.bucket_prefix
```

This is used to access a value defined inside a `locals` block.

Here, it returns:

```text
my-app-dev-
```

**3. String Interpolation**

```hcl
bucket_prefix = "my-app-${var.environment}-"
```

String interpolation allows us to insert a variable or expression inside a string.

Since modern HCL also supports direct expressions, `${...}` is mainly needed when inserting an expression into a larger string.

For example:

```hcl
# Using interpolation
name = "my-app-${var.environment}"

# Using direct expression
name = var.environment
```

Both are valid, but they serve different purposes.

## 6. Understanding Terraform Configuration Files

Terraform configurations are commonly divided into multiple `.tf` files to keep the project organized.

For this example, we will use:

```text
terraform-learning/
│
├── main.tf
└── outputs.tf
```

### main.tf

This file contains our variable and local value definitions.

```hcl
variable "environment" {
  description = "Name of the environment"
  type        = string
  default     = "dev"
}

locals {
  project_name = "terraform-learning"
  full_name    = "${local.project_name}-${var.environment}"
}
```

### outputs.tf

This file contains the output definition.

```hcl
output "resource_name_prefix" {
  value = local.full_name
}
```

**Important:** Terraform automatically loads `.tf` files from the same working directory. The filenames help organize the configuration, but the blocks do not have to be in a particular file.

## 7. Practical Lab — Working With HCL

Let's create a simple Terraform configuration to understand variables, locals, and outputs.

### Step 1: Create a Project Directory

```bash
mkdir terraform-hcl-demo
cd terraform-hcl-demo
```

### Step 2: Create main.tf

```hcl
variable "environment" {
  description = "Name of the environment"
  type        = string
  default     = "dev"
}

locals {
  project_name = "terraform-learning"
  full_name    = "${local.project_name}-${var.environment}"
}
```

### Step 3: Create outputs.tf

```hcl
output "resource_name_prefix" {
  value = local.full_name
}
```

### Step 4: Initialize Terraform

```bash
terraform init
```

This initializes the working directory and prepares Terraform to work with the configuration.

### Step 5: Format the Configuration

```bash
terraform fmt
```

This automatically formats your Terraform files according to standard HCL formatting rules.

### Step 6: Validate the Configuration

```bash
terraform validate
```

This checks whether your Terraform configuration is syntactically valid and internally consistent.

### Step 7: Preview the Changes

```bash
terraform plan
```

Terraform prepares an execution plan for the configuration.

Since this example does not define any infrastructure resources, there are no cloud resources to create.

### Step 8: Apply the Configuration

```bash
terraform apply
```

Confirm the operation when prompted.

Terraform evaluates the configuration and records the output in its local state.

### Step 9: Display the Output

```bash
terraform output
```

**Expected Output:**

```text
resource_name_prefix = "terraform-learning-dev"
```

### Step 10: Destroy the Configuration

```bash
terraform destroy
```

This removes Terraform-managed objects from the state. In this particular example, there are no cloud resources to delete.

**Note:** Terraform may still retain its local state file after this operation. You can remove the local state and other generated files manually if you no longer need the working directory.

## 8. Practice Tasks

Try completing these tasks yourself:

1. Create a variable named `project_name` with a string value.
2. Create a variable named `instance_count` with a number value.
3. Create a Boolean variable named `monitoring_enabled`.
4. Create a list variable containing ports `22`, `80`, and `443`.
5. Create a map variable containing environment and project tags.
6. Create a local value that combines the project name and environment.
7. Create an output block to display the combined name.
8. Run `terraform fmt`, `terraform validate`, and `terraform plan`.
9. Explain the difference between variables, locals, and outputs.

## 9. Key Takeaway

HCL is the language used to write Terraform configurations.

It helps us define infrastructure in a structured and readable way using blocks, arguments, expressions, and values.

**Remember:**
- Variables are used to accept input.
- Locals are used to store reusable values.
- Outputs are used to display useful information.
- Data types define what kind of values we can store.
- Expressions help us combine and reference values.

## 10. Quick Revision

| Concept | Meaning |
|---|---|
| HCL | HashiCorp Configuration Language |
| Block | A section that groups related configuration |
| Argument | A named setting assigned a value |
| Variable | Accepts input values |
| Local | Stores reusable values |
| Output | Displays useful information |
| String | Stores text |
| Number | Stores numeric values |
| Bool | Stores true or false |
| List | Stores ordered values |
| Map | Stores key-value pairs |
| Expression | Combines or references values |
| `var.name` | References an input variable |
| `local.name` | References a local value |

**DevOps Interview Tip:** Be prepared to explain what HCL is, the difference between blocks and arguments, the different Terraform data types, and the difference between variables, locals, and outputs.
