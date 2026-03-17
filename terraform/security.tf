resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Security group for web application"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description = "App Port"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow only HTTPS outbound (instead of all ports)
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "devops-assessment-sg"
  }
}