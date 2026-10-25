resource "aws_security_group" "frontend-sg" {
  name        = "frontend-sg"
  description = "Security group for frontend EC2 instance"
  vpc_id      = aws_vpc.wp-vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
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
    Name    = "frontend-sg"
    Project = var.project
    Owner   = var.owner
  }
}

resource "aws_security_group" "backend-sg" {
  name        = "backend-sg"
  description = "Security group for backend EC2 instance"
  vpc_id      = aws_vpc.wp-vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend-sg.id]
  }

  ingress {
    description     = "SSH"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend-sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  depends_on = [
    aws_security_group.frontend-sg
  ]
  tags = {
    Name    = "backend-sg"
    Project = var.project
    Owner   = var.owner
  }
}
