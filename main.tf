terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.64.0"
    }
  }
  backend "s3" {
    bucket = "jirivasm-test-bucket"
    key    = "ansible-practice/tfstatefile"
    region = "us-east-2"
  }
}
provider aws{
  region = "us-east-2"
}


