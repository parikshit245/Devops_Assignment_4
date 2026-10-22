output "instance_id" {
  description = "EC2 instance running the catalog."
  value       = aws_instance.app.id
}

output "catalog_url" {
  description = "Public URL of the deployed catalog."
  value       = "http://${aws_instance.app.public_ip}"
}

output "instance_public_ip" {
  description = "Public IP address of the catalog EC2 instance."
  value       = aws_instance.app.public_ip
}
