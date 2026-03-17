# devops-assessment

## AI Usage Log (Security Remediation)

**The Exact AI Prompt Used:**
> "I am running a Trivy security scan on my Terraform infrastructure code. The scan failed and reported a HIGH vulnerability regarding port 22. Analyze the following Terraform security group configuration, explain the security risk, and provide the rewritten code to fix the vulnerability:
> [Inserted security.tf code]"

**Summary of Identified Risks:**
The AI identified that opening SSH (Port 22) to `0.0.0.0/0` exposes the EC2 management port to the entire public internet. This misconfiguration makes the server highly susceptible to automated brute-force attacks, port scanning, and unauthorized access attempts from malicious actors globally.

**How the AI-Recommended Changes Improved Security:**
The AI recommended changing the ingress CIDR block for port 22 from the global wildcard (`0.0.0.0/0`) to a restricted, specific IP address (my local public IP) with a `/32` subnet mask. This adheres to the Principle of Least Privilege, ensuring that only my trusted network can initiate SSH connections to the compute instance, effectively neutralizing the vulnerability while maintaining operational access.