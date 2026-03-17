resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Security group for web application"
  vpc_id      = aws_vpc.main_vpc.id

  # REMEDIATED VULNERABILITY: SSH restricted to a specific trusted IP
  ingress {
    description = "SSH from Admin IP only"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["182.48.218.175/32"]
  }

  # Open port 3000 for our Node.js app (Open to the world is acceptable for a public web app)
  ingress {
    description = "App Port"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    # trivy:ignore:AVD-AWS-0104 (Accepted Risk: Needs outbound internet to download Docker)
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "devops-assessment-sg"
  }
}