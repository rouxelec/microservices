terraform {
  backend s3 {
    encrypt        = true
    bucket         = "881108841750-manal-fun-project-terraform-state"
    dynamodb_table = "881108841750-manal-fun-project-terraform-state-lock"
    region         = "ca-central-1"
    key            = "tf-state"
  }
}
