<div align="center">
<img src="https://user-images.githubusercontent.com/47891196/139104117-aa9c2943-37da-4534-a584-e4e5ff5bf69a.png" width="350px" />
</div>

# K8S-IA
Treinar subir um k8s via IA

Repositório de estudo e deploy local de Kubernetes com Terraform, Minikube e uma aplicação Python + PostgreSQL, incluindo monitoramento via Helm (Prometheus + Grafana).



1️⃣ setup-minikube.sh – Cria e inicializa Minikube, configura kubectl.

2️⃣ main.tf atualizado – Com image_pull_policy = "IfNotPresent" e ajustes finais.

3️⃣ README passo a passo atualizado – Com todos os comandos corrigidos e fluxo completo.

Estrutura do projeto

```
K8S-IA/
├── app/ # Aplicação Python
│ ├── app.py
│ ├── Dockerfile
│ └── requirements.txt
├── helm/ # Charts Helm para monitoramento
│ └── prometheus-grafana.tf
├── kind-config.yaml # Config Kind (opcional)
├── LICENSE
├── README.md
└── terraform/ # Terraform para Kubernetes
├── main.tf
├── output.tf
├── providers.tf
├── variables.tf
├── terraform.tfstate
└── setup-minikube.sh
```
## Requisitos

- Docker instalado
- Minikube ou Kind instalado
- Kubectl instalado
- Terraform >= 1.6.0

---

## Passo a passo completo

✅ 1️⃣ 1.0 Clonar o repositório

```
git clone https://github.com/orbite82/K8S-IA.git
cd K8S-IA/terraform
```

✅ 1️⃣ 1.1 Build da aplicação Docker
```bash
cd app
docker build -t my-local-app:latest .
docker images

O script setup-minikube.sh automatiza a criação do cluster Minikube e configuração do kubectl.

Passo a passo para executar

✅ 2. Build da aplicação Docker

Dentro da pasta app/:

```
cd ../app
docker build -t my-local-app:latest .
docker images
```
✅ 3. Inicializar Minikube

✅ Passos para corrigir de forma definitiva

Crie um cluster Kubernetes local
Você precisa de um cluster ativo. Pode ser Minikube ou Kind. Exemplo com Minikube:

```
minikube start --profile k8s-ia --driver=docker
```
---

# OU

setup-minikube.sh

Crie esse arquivo dentro de terraform/:

```
#!/bin/bash

# ======================================================
# Script para criar/configurar Minikube para K8S-IA
# ======================================================

PROFILE_NAME="k8s-ia"
DRIVER="docker"
K8S_VERSION="v1.35.1"

echo "🚀 Iniciando Minikube (profile=$PROFILE_NAME)..."

# Inicia Minikube
minikube start --profile $PROFILE_NAME --driver=$DRIVER --kubernetes-version=$K8S_VERSION

# Habilita addons essenciais
minikube addons enable storage-provisioner --profile $PROFILE_NAME

# Configura kubectl para usar o cluster correto
kubectl config use-context $PROFILE_NAME

echo "✅ Minikube pronto! Cluster ativo:"
```

```
kubectl cluster-info
kubectl get nodes
```

Verifique nodes e namespace padrão:

```
kubectl get nodes
kubectl get namespaces
```


✅ 4. Configurar provider do Terraform

No arquivo terraform/providers.tf:

```
provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "k8s-ia"
}

```
Isso garante que o Terraform se conecte ao cluster correto.

main.tf atualizado

```
# ======================
# Namespace
# ======================
resource "kubernetes_namespace_v1" "app_ns" {
  metadata {
    name = var.namespace_name
  }
}

# ======================
# Deployment: Aplicação
# ======================
resource "kubernetes_deployment_v1" "app" {
  metadata {
    name      = "my-app"
    namespace = kubernetes_namespace_v1.app_ns.metadata[0].name
    labels = {
      app = "my-app"
    }
  }

  spec {
    replicas = var.app_replicas

    selector {
      match_labels = {
        app = "my-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "my-app"
        }
      }

      spec {
        container {
          name  = "my-app"
          image = var.app_image
          image_pull_policy = "IfNotPresent"

          port {
            container_port = var.app_container_port
          }

          resources {
            limits = {
              cpu    = "500m"
              memory = "256Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "128Mi"
            }
          }
        }
      }
    }
  }
}

# ======================
# Deployment: PostgreSQL
# ======================
resource "kubernetes_deployment_v1" "postgres" {
  metadata {
    name      = "postgres"
    namespace = kubernetes_namespace_v1.app_ns.metadata[0].name
    labels = {
      app = "postgres"
    }
  }

  spec {
    replicas = var.postgres_replicas

    selector {
      match_labels = {
        app = "postgres"
      }
    }

    template {
      metadata {
        labels = {
          app = "postgres"
        }
      }

      spec {
        container {
          name  = "postgres"
          image = var.postgres_image
          image_pull_policy = "IfNotPresent"

          port {
            container_port = var.postgres_port
          }

          env {
            name  = "POSTGRES_USER"
            value = var.postgres_user
          }
          env {
            name  = "POSTGRES_PASSWORD"
            value = var.postgres_password
          }
          env {
            name  = "POSTGRES_DB"
            value = var.postgres_db
          }

          resources {
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "256Mi"
            }
          }
        }
      }
    }
  }
}

# ======================
# Service: Aplicação
# ======================
resource "kubernetes_service_v1" "app_service" {
  metadata {
    name      = "my-app-service"
    namespace = kubernetes_namespace_v1.app_ns.metadata[0].name
  }

  spec {
    selector = {
      app = "my-app"
    }

    port {
      port        = 80
      target_port = var.app_container_port
    }

    type = "ClusterIP"
  }
}

# ======================
# Service: PostgreSQL
# ======================
resource "kubernetes_service_v1" "postgres_service" {
  metadata {
    name      = "postgres-service"
    namespace = kubernetes_namespace_v1.app_ns.metadata[0].name
  }

  spec {
    selector = {
      app = "postgres"
    }

    port {
      port        = 5432
      target_port = var.postgres_port
    }

    type = "ClusterIP"
  }
}
```
🔑 Observação: image_pull_policy = "IfNotPresent" evita erros de ErrImagePull usando imagens locais do Docker.

✅ 5. Inicializar Terraform

Dentro da pasta terraform/:

```
cd terraform
terraform init -upgrade
```

✅ 6. Planejar recursos

```
terraform plan
```
Confirme que serão adicionados 5 recursos:
 Namespace app-namespace
 Deployment my-app
 Deployment postgres
 Service my-app-service
 Service postgres-service

✅ 7. Aplicar os recursos no cluster

```
terraform apply
```
Digite yes quando solicitado
O Terraform cria todos os recursos no cluster k8s-ia

✅ 8. Verificar os recursos no Kubernetes

```
kubectl get namespaces
kubectl get deployments -n app-namespace
kubectl get pods -n app-namespace
kubectl get svc -n app-namespace
```
Confirme que deployments, pods e services estão rodando no namespace app-namespace.

✅ 9. Acessar a aplicação localmente

```
kubectl port-forward svc/my-app-service 8080:80 -n app-namespace
# Abra no navegador: http://localhost:8080
```

✅ 10. Acessar o PostgreSQL

```
kubectl port-forward svc/postgres-service 5432:5432 -n app-namespace
```

Conectar via cliente PostgreSQL:

```
Host: localhost
Port: 5432
User: admin
Password: admin123
Database: mydb
```

✅ Monitoramento (opcional)

Se Helm estiver configurado, rode os charts em helm/prometheus-grafana.tf.

🧠 Dicas importantes

Sempre que mudar arquivos .tf, rode:

```
terraform plan
terraform apply
```

Se mudar o contexto do cluster, verifique:

```
kubectl config current-context
kubectl config use-context k8s-ia
```

Para remover todos os recursos do cluster:

```
terraform destroy
```

🚀 Próximos passos

Depois de implantar com sucesso, você pode:

Automatizar em um pipeline CI/CD
Adicionar Ingress para expor a aplicação
Adicionar Secrets/ConfigMaps via Terraform
Gerenciar volumes persistentes

💡 Como resolver:

Revisar se o cluster está limpo
Você está usando Minikube. Antes de reaplicar, é mais seguro destruir os recursos antigos que podem estar conflitantes:

```
kubectl delete deployment my-app -n app-namespace
kubectl delete deployment postgres -n app-namespace
kubectl delete svc my-app-service -n app-namespace
kubectl delete svc postgres-service -n app-namespace
kubectl delete namespace app-namespace
```

Isso limpa tudo do Terraform no cluster.

Opcional: Resetar o estado local do Terraform
Caso queira “começar do zero” no Terraform:

```
rm terraform/terraform.tfstate
rm terraform/terraform.tfstate.backup
```

⚠️ Faça isso apenas se você não tem recursos críticos aplicados, pois você vai perder o controle do estado atual.

Aplicar novamente
Inicialize o Terraform e aplique:

```
cd terraform
terraform init -upgrade
terraform plan
terraform apply
```
Com image_pull_policy = "IfNotPresent" adicionado no main.tf, suas imagens locais serão usadas e o ErrImagePull não vai mais ocorrer.
