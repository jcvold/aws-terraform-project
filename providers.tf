terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.22.0"
    }
  }
}

# Note: this approach only works when devloping locally. In production, for credentials
# you sould use secrets, environmet variables, etc.
provider "aws" {
  region                   = var.region
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "vscode"
}
