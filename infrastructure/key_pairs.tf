resource "aws_key_pair" "myssh-key" {
    key_name = "ssh-key"
    public_key = file("~/aws/aws_keys/id_rsa.pub")
}