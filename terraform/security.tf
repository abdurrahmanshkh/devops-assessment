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

  # REMOVE the old egress block completely

  tags = {
    Name = "devops-assessment-sg"
  }
}

data "aws_prefix_list" "s3" {
  name = "com.amazonaws.${var.aws_region}.s3"
}

resource "aws_security_group_rule" "egress_s3" {
  type              = "egress"
  security_group_id = aws_security_group.web_sg.id
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  prefix_list_ids   = [data.aws_prefix_list.s3.id]
  description       = "Allow HTTPS only to S3"
}