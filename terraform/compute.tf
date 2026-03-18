data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  # SECURITY FIX 1: Encrypt the root hard drive
  root_block_device {
    encrypted = true
  }

  # SECURITY FIX 2: Enforce IMDSv2 metadata tokens
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
              app.get('/', (req, res) => {
                  res.send(`
                  <!DOCTYPE html>
                  <html lang="en">
                  <head>
                      <meta charset="UTF-8">
                      <meta name="viewport" content="width=device-width, initial-scale=1.0">
                      <title>DevOps Assessment | Secure Deployment</title>
                      <script src="https://cdn.tailwindcss.com"></script>
                  </head>
                  <body class="bg-gray-900 text-white flex items-center justify-center h-screen m-0 font-sans">
                      <div class="bg-gray-800 p-8 rounded-xl shadow-2xl border border-gray-700 max-w-md w-full text-center">
                          <div class="inline-flex items-center bg-green-900/30 text-green-400 px-4 py-1.5 rounded-full text-sm font-semibold mb-6 border border-green-800/50">
                              <span class="w-2 h-2 bg-green-500 rounded-full mr-2 shadow-[0_0_8px_rgba(34,197,94,1)]"></span>
                              System Online & Secure
                          </div>
                          <h1 class="text-2xl font-bold mb-2">DevOps Assessment</h1>
                          <p class="text-gray-400 mb-8 text-sm">Successfully deployed via Terraform, Docker, and Jenkins automated CI/CD pipeline.</p>
                          <div class="grid grid-cols-2 gap-4 text-left">
                              <div class="bg-gray-900/50 p-4 rounded-lg border border-gray-700"><div class="text-xs text-gray-500 uppercase tracking-wider mb-1">Infrastructure</div><div class="font-semibold text-gray-200">AWS EC2</div></div>
                              <div class="bg-gray-900/50 p-4 rounded-lg border border-gray-700"><div class="text-xs text-gray-500 uppercase tracking-wider mb-1">Security Scan</div><div class="font-semibold text-green-400">Passed (Trivy)</div></div>
                              <div class="bg-gray-900/50 p-4 rounded-lg border border-gray-700"><div class="text-xs text-gray-500 uppercase tracking-wider mb-1">Container</div><div class="font-semibold text-gray-200">Docker</div></div>
                              <div class="bg-gray-900/50 p-4 rounded-lg border border-gray-700"><div class="text-xs text-gray-500 uppercase tracking-wider mb-1">AI Remediation</div><div class="font-semibold text-gray-200">Completed</div></div>
                          </div>
                          <div class="mt-8 text-xs text-gray-500 border-t border-gray-700 pt-4">Automated Deployment Pipeline</div>
                      </div>
                  </body>
                  </html>
                  `);
              });
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