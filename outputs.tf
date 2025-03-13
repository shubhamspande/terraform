output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "web_instance_id" {
  description = "The ID of the EC2 instance in the Web subnet"
  value       = aws_instance.web_instance.id
}

output "web_instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.web_instance.private_ip
}
