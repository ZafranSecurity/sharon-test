# Configure the S3 backend for each Terraform project automatically
remote_state {
  backend = "s3"
  generate = {
    path      = "00-backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket    = "zafran-terraform"
    key       = "${path_relative_to_include()}/terraform.tfstate"
    region    = "us-east-2"
    encrypt   = true
    profile   = "default-legacy"
  }
}

# Configure the providers for each Terraform project automatically
generate "provider" {
  path      = "00-provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region  = "us-east-2"
}
EOF
}
