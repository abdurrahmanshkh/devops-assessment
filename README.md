# DevSecOps Assessment: Automated Infrastructure & Security Pipeline

## Project Overview
This project demonstrates a complete DevSecOps lifecycle. It features a containerized Node.js application, infrastructure provisioned via Terraform, and an automated Jenkins CI/CD pipeline that integrates Trivy for infrastructure security scanning and AI-driven vulnerability remediation.

## Architecture & Workflow
1. **Source Control:** Code is maintained in GitHub.
2. **CI/CD (Jenkins):** A local Jenkins server (running via Docker) pulls the code upon execution.
3. **Security Scan (Trivy):** Jenkins runs a Trivy scan against the Terraform configuration to detect misconfigurations before deployment.
4. **Infrastructure as Code (Terraform):** Terraform provisions the required AWS networking (VPC, Subnets, Internet Gateway) and compute resources.
5. **Deployment:** An EC2 instance is launched with a `user_data` script that automatically installs Docker, pulls the application code, and spins up the Node.js web container.

## Tools & Technologies
* **Cloud Provider:** AWS (Amazon Web Services)
* **Infrastructure as Code:** Terraform
* **CI/CD:** Jenkins (Custom Dockerized environment)
* **Security Scanner:** Trivy by Aqua Security
* **Containerization:** Docker & Docker Compose
* **Application:** Node.js / Express.js / Tailwind CSS

---

## Before & After Security Report

### Initial Failing State (Intentional Vulnerability)
Initially, the `security.tf` file was configured with Port 22 (SSH) open to `0.0.0.0/0`. The Jenkins pipeline successfully caught this misconfiguration during the "Infrastructure Security Scan" stage, failing the build and preventing a vulnerable deployment.

![Failing Jenkins Scan]([Insert link to your failing Jenkins screenshot here])
*(Jenkins pipeline failing due to Trivy detecting the open SSH port)*

### Final Passing State (Secured)
After applying AI-recommended remediations, the SSH port was restricted, and strict egress/ingress rules were applied. The pipeline was re-run and passed successfully, proceeding to the `terraform plan` stage.

![Passing Jenkins Scan]([Insert link to your passing Jenkins screenshot here])
*(Jenkins pipeline passing after Terraform security fixes)*

---

## AI Usage Log (Security Remediation)

**The Exact AI Prompt Used:**
> "I am running a Trivy security scan on my Terraform infrastructure code. The scan failed and reported a HIGH vulnerability regarding port 22. Analyze the following Terraform security group configuration, explain the security risk, and provide the rewritten code to fix the vulnerability: [Inserted security.tf code]"

**Summary of Identified Risks:**
The AI identified that opening SSH (Port 22) to `0.0.0.0/0` exposes the EC2 management port to the entire public internet. This misconfiguration makes the server highly susceptible to automated brute-force attacks, port scanning, and unauthorized access attempts from malicious actors globally.

**How the AI-Recommended Changes Improved Security:**
The AI recommended changing the ingress CIDR block for port 22 from the global wildcard (`0.0.0.0/0`) to a restricted, specific IP address (the administrator's local IP) with a `/32` subnet mask. This adheres to the Principle of Least Privilege, ensuring that only trusted networks can initiate SSH connections to the compute instance, effectively neutralizing the vulnerability while maintaining operational access. Additional remediations included encrypting the EBS root volume and enforcing IMDSv2 metadata tokens.

---

## Application Deployment Verification

The application was successfully deployed to AWS and is accessible here:

**Live App:** http://13.233.186.53:3000
