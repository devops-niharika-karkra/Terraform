variable "environment" {
  description = "Environment label used in names"
  type        = string
  default     = "dev"
}

variable "allowed_ports" {
  description = "Example list of ports"
  type        = list(number)
  default     = [22, 80, 443]
}

locals {
  project_name = "terraform-learning"
  name_prefix  = "${local.project_name}-${var.environment}"
  ports_text   = join(", ", [for port in var.allowed_ports : tostring(port)])
}
