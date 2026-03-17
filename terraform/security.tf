resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Security group for web application"
  vpc_id      = aws_vpc.main_vpc.id

  # INTENTIONAL VULNERABILITY: SSH open to the world
  ingress {
    description = "SSH from anywhere - INTENTIONAL VULNERABILITY"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Open port 3000 for our Node.js app
  ingress {
    description = "App Port"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "devops-assessment-sg"
  }
}