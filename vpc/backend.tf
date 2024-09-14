terraform {
    backend "s3" { 
      bucket         = "tmbb-terraform-lee-tfstate"
      key            = "Projects/terraform_playground/vpc/terraform.tfstate"
      region         = "ap-northeast-3"  
      encrypt        = true
      dynamodb_table = "terraform-lock"
    }
}
