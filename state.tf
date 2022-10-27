terraform {
  backend "s3" {
    bucket         = "terraform-aws-infrastructure"
    key            = "state/ap-southeast-1/apps/demo"
    region         = "ap-southeast-1"
    encrypt        = true
    acl            = "private"
    dynamodb_table = "demo-terraform"
  }
}
