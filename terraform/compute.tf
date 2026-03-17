resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  # SECURITY FIX 1: Encrypt the root hard drive (Resolves AWS-0131)
  root_block_device {
    encrypted = true
  }

  # SECURITY FIX 2: Enforce IMDSv2 metadata tokens (Resolves AWS-0028)
  metadata_options {
    http_tokens = "required"
  }

  user_data = <<-EOF
              #!/bin/bash
              # 1. Update and install Docker
              apt-get update -y
              apt-get install -y apt-transport-https ca-certificates curl software-properties-common
              curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
              add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
              apt-get update -y
              apt-get install -y docker-ce docker-compose-plugin

              systemctl start docker
              systemctl enable docker
              usermod -aG docker ubuntu

              # 2. Create app directory
              mkdir -p /home/ubuntu/app
              cd /home/ubuntu/app

              # 3. Write application files
              cat << 'EOT' > package.json
              {
                "name": "devops-assessment-app",
                "version": "1.0.0",
                "main": "server.js",
                "scripts": { "start": "node server.js" },
                "dependencies": { "express": "^4.18.2" }
              }
              EOT

              cat << 'EOT' > server.js
              const express = require('express');
              const app = express();
              app.get('/', (req, res) => res.send('<h1>DevOps Assessment</h1><p>Application is securely deployed via Terraform and Docker!</p>'));
              app.listen(3000, '0.0.0.0', () => console.log('Server running on port 3000'));
              EOT

              cat << 'EOT' > Dockerfile
              FROM node:18-alpine
              WORKDIR /usr/src/app
              COPY package*.json ./
              RUN npm install
              COPY . .
              EXPOSE 3000
              CMD ["npm", "start"]
              EOT

              cat << 'EOT' > docker-compose.yml
              version: '3.8'
              services:
                web:
                  build: .
                  ports:
                    - "3000:3000"
              EOT

              # 4. Build and run the container
              docker compose up --build -d
              EOF

  tags = {
    Name = "devops-assessment-web-instance"
  }
}