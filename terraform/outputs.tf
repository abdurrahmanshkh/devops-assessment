output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.web_server.public_ip
}

output "application_url" {
  description = "URL to access the web application"
  value       = "http://${aws_instance.web_server.public_ip}:3000"
}