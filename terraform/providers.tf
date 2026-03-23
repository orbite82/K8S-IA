##########################################
# PROVIDERS.TF - Configuração dos provedores
##########################################

# Provedor Kubernetes
provider "kubernetes" {
  description = "Conecta ao cluster Kubernetes local via kubeconfig"
  config_path = "~/.kube/config"
}

# Provedor Helm
provider "helm" {
  description = "Usa Helm para instalar charts dentro do cluster Kubernetes"
  kubernetes {
    config_path = "~/.kube/config"
  }
}