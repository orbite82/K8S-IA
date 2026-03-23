terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.19"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}