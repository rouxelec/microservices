resource "aws_dynamodb_table" "microservice" {
  name           = "Microservice"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "UserId"

  attribute {
    name = "UserId"
    type = "S"
  }
}

resource "aws_dynamodb_table" "deployment" {
  name           = "Deployment"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "id"
  range_key      = "when"

  attribute {
    name = "id"
    type = "S"
  }

    attribute {
    name = "when"
    type = "S"
  }
}

resource "null_resource" "dynamodb" {
  depends_on = [aws_dynamodb_table.microservice]

  provisioner "local-exec" {
    command = "aws dynamodb put-item --table-name Microservice --region us-east-1 --item '{\"UserId\":{\"S\":\"api_version\"},\"version\":{\"S\":\"4\"}}'"
  }
}
