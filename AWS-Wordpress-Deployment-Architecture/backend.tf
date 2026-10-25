resource "aws_instance" "wp-ec2-private" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.wp-subnet-private.id
  vpc_security_group_ids      = [aws_security_group.backend-sg.id]
  key_name                    = var.key_name
  user_data                   = file("backend_user-data.sh")
  user_data_replace_on_change = true
  depends_on = [
    aws_route_table_association.wp-private-rt-assoc,
    aws_nat_gateway.wp-nat-gateway
  ]


  tags = {
    Name    = "wp-ec2-private"
    Project = var.project
    Owner   = var.owner
  }
} 
