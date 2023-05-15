# Terraform-ansible-practice
There are two folders on this repo:
  -Terraform
    -where all the infrastructure is created: 1 master node whit ansible, git and more programs installed, and 3 slave nodes
    -the state file is safley stored on my s3 bucket
  -Ansible
    -Here I have the config file to configure who is master and who is slave.
      -the IPs will not work since they are hard coded and every time the vm are created there are new ips
     -the host file to oorganize the hosts as groups add a name and where all the ansible commands and playbooks will be performed.
    
    
