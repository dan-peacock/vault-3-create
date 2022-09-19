provider "vault" {
  address = var.vault_url
  token = var.vault_token
}

data "vault_aws_access_credentials" "creds" {
  backend = "aws-dynamic-creds/creds/"
  role    = "aws-role"
}

provider "aws" {
  region     = "eu-west-2"
  access_key = data.vault_aws_access_credentials.creds.access_key
  secret_key = data.vault_aws_access_credentials.creds.secret_key
}

resource "aws_dynamodb_table" "customers_db" {
  name           = "customers"
  read_capacity  = 10
  write_capacity = 10
  hash_key       = "customer_id"

  attribute {
    name = "customer_id"
    type = "S"
  }
}

resource "aws_dynamodb_table_item" "customers_items" {
  table_name = aws_dynamodb_table.customers_db.name
  hash_key   = aws_dynamodb_table.customers_db.hash_key

  item = <<ITEM
{
  "customer_id": {"S": "1"},
  "FirstName": {"S": "Dan"},
  "Surname": {"S": "Peacock"},
  "CCN": {"S": "1111-2222-3333-4444"}
}
ITEM
}
