data "aws_ami" "amazon_linux_ami" {
  most_recent = true
  owners      = ["amazon"]
    filter {
    name   = "name"
    values = ["al2023-ami-2023.0.20230503.0-kernel-6.1-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

}
data "aws_vpc" "default_vpc"{
    default = true
}
resource "aws_instance" "my_ec2" {
    //count = 4

    instance_type = "t2.micro"
    ami = "${data.aws_ami.amazon_linux_ami.id}"
    key_name = aws_key_pair.myssh-key.key_name
    tags = {
        //Name = count.index == 0 ? "master" : "server_${count.index}"
        Name = "test"
    }
    vpc_security_group_ids = [aws_security_group.allow_ssh.id]

    connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("~/aws/aws_keys/id_rsa")
    host = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "echo updating yum",
      "sudo yum update -y",
      "echo installing pip",
      "sudo curl -O https://bootstrap.pypa.io/get-pip.py",
      "python3 get-pip.py --user",
      "echo installing ansible",
      "python3 -m pip install --user ansible",
      "python3 -m pip install --upgrade --user ansible",
      "ansible --version"
    ]
  }
}

resource "aws_key_pair" "myssh-key" {
    key_name = "ssh-key"
    public_key = file("~/aws/aws_keys/id_rsa.pub")
}
resource "aws_security_group" "allow_ssh"{
    name        = "allow_ssh"
    description = "Allow ssh inbound traffic"
    vpc_id      = data.aws_vpc.default_vpc.id

    ingress {
        description      = "Allow SSH"
        from_port        = 22
        to_port          = 22
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
