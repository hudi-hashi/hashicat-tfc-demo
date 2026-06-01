terraform {
  required_providers {
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.54.0"
    }
    
    aws = {
      source = "hashicorp/aws"
      version = "4.30.0"
    }
  }
}

provider "hcp" {}

 provider "confluence" {
 	site  = "demo.atlassian.net"
 	user  = "mydemouser@hashicups.com"
 	token = "ATATT3xFfGF02JG_nkD8hjd_0sIDnUQS462OOvCVkM5raxtU-lseO_cCCiT6S5euEHk1HlX5YElzheTbBqMzQsJwM46wJA_0rnCcloJpVyTlywmSUCAGHeNWbHjaP3YHb-OtAAlszK4pknljt10rCVh-n3cK_KPvB1b_PATe_PYNdYoBk3N4LE8=2D12EAEF"
 }

 resource "confluence_content" "default" {
 	space = "MYSPACE"
 	title = "Example Page"
 	body  = "<p>This page was built with Terraform</p>"
 }
provider "aws" {
  access_key = "ASIAXAUV5ITFVV23EEI8"
  secret_key = "qlkqXSWZU5IglHw1m1Jgl+7GmMiimIbIwK30moydb"
  token = ""
  region = var.region
}

#PACKER ITERATION
data "hcp_packer_iteration" "hashicat" {
  bucket_name = "hashicat-demo"
  channel     = "latest"
}

#PACKER IMAGE
data "hcp_packer_image" "ubuntu_us_east_1" {
  bucket_name    = "hashicat-demo"
  cloud_provider = "aws"
  iteration_id   = data.hcp_packer_iteration.hashicat.ulid
  region         = "us-east-1"
}

module "hashicat" {
  source  = "app.terraform.io/hashi-hudi/hashicat/aws"
  version = "1.0.1"
  instance_type = var.instance_type
  region = var.region
  instance_ami = data.hcp_packer_image.ubuntu_us_east_1.cloud_image_id
}
