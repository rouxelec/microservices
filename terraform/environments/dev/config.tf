terraform {
  backend s3 {
    encrypt        = true
    bucket         = "n1-us-east-1-705609561939-fun-project-terraform-state"
    dynamodb_table = "n1-us-east-1-705609561939-fun-project-terraform-state-lock"
    region         = "us-east-1"
    key            = "tf-state"
  }
}
