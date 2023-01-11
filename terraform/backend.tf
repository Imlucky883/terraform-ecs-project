terraform {
  backend "s3"{
    bucket = "my-backend-bucket2345"
    key = "/apps/state.tfstate"
  }
}