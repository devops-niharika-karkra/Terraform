resource "aws_instance" "wp-ec2-public-1" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.wp-subnet-public-1.id
  vpc_security_group_ids = [aws_security_group.frontend-sg.id]
  key_name               = var.key_name
  user_data = replace(
    file("frontend_user-data.sh"),
    "__DB_HOST__",
    aws_instance.wp-ec2-private.private_ip
  )
  user_data_replace_on_change = true


  tags = {
    Name    = "wp-ec2-public-1"
    Project = var.project
    Owner   = var.owner
  }
}

resource "aws_instance" "wp-ec2-public-2" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.wp-subnet-public-2.id
  vpc_security_group_ids = [aws_security_group.frontend-sg.id]
  key_name               = var.key_name
  user_data = replace(
    file("frontend_user-data.sh"),
    "__DB_HOST__",
    aws_instance.wp-ec2-private.private_ip
  )
  user_data_replace_on_change = true
  tags = {
    Name    = "wp-ec2-public-2"
    Project = var.project
    Owner   = var.owner
  }
}

