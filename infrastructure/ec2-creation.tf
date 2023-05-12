resource "aws_instance" "my_ec2_master_node" {
      
    instance_type = "t2.micro"
    ami = "${data.aws_ami.amazon_linux_ami.id}"
    key_name = aws_key_pair.myssh-key.key_name
    tags = {
        Name = "master"
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
      "ansible --version",
      "echo installing git",
      "sudo yum install git -y",
      "git clone https://github.com/jirivasm/ansible-practice"
    ]
  }
  provisioner "local-exec"{
    command = "scp -i ~/aws/aws_keys/id_rsa ~/aws/aws_keys/id_rsa ec2-user@${aws_instance.my_ec2_master_node.public_dns}:~/.ssh"
  }
}
resource "aws_instance" "my_ec2_slave_nodes" {
    count = 3

    
    instance_type = "t2.micro"
    ami = "${data.aws_ami.amazon_linux_ami.id}"
    key_name = aws_key_pair.myssh-key.key_name
    tags = {
        Name = "server_${count.index}"
    }
    vpc_security_group_ids = [aws_security_group.allow_ssh.id]

}



