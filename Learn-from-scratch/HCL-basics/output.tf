output "name_prefix" {
  description = "Calculated name prefix"
  value       = local.name_prefix
}

output "allowed_ports_text" {
  description = "Ports rendered as a comma-separated string"
  value       = local.ports_text
}
