resource "aws_security_group" "allow_ssh"{
    name        = "allow_ssh and http"
    description = "Allow ssh and http inbound traffic"
    vpc_id      = data.aws_vpc.default_vpc.id

    ingress {
        description      = "Allow SSH"
        from_port        = 22
        to_port          = 22
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
    }
    ingress {
        description      = "Allow http"
        from_port        = 80
        to_port          = 80
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
    }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
    }

  tags = {
    Name = "allow_ssh"
  }
}
