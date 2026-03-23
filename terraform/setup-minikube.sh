#!/bin/bash
set -e

# ============================
# Checa se Minikube está instalado
# ============================
if ! command -v minikube &> /dev/null
then
    echo "Minikube não encontrado. Instalando..."
    # Exemplo para Ubuntu/Debian
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
    sudo dpkg -i minikube_latest_amd64.deb
fi

# ============================
# Inicia o cluster Minikube
# ============================
CLUSTER_NAME="k8s-ia"
echo "Iniciando cluster Minikube: $CLUSTER_NAME"
minikube start -p $CLUSTER_NAME --driver=docker

# ============================
# Configura kubectl para usar o cluster
# ============================
echo "Configurando kubectl para usar o cluster Minikube..."
kubectl config use-context $CLUSTER_NAME

# ============================
# Mostra status
# ============================
kubectl cluster-info
kubectl get nodes

echo "Minikube pronto. Agora rode: terraform apply"