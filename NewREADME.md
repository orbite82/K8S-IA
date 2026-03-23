📘 Documentação Completa — Projeto K8S‑IA

Objetivo: Treinar e subir um ambiente Kubernetes local (com Minikube/Kind), provisionar recursos via Terraform, empacotar e rodar uma aplicação Python + PostgreSQL, e habilitar monitoramento com Helm.

📁 Estrutura do Projeto

```
K8S‑IA/
├── app/                     # Aplicação Python
│   ├── app.py
│   ├── Dockerfile
│   └── requirements.txt
├── helm/                    # Charts / manifests de monitoramento
│   └── prometheus-grafana.tf
├── kind-config.yaml         # Configuração alternativa para Kind (opc.)
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── providers.tf
│   ├── output.tf
│   ├── setup‑minikube.sh
│   └── terraform.tfstate   # (gerado)
├── LICENSE
└── README.md                # Guia atual
```

Todos os passos abaixo assumem que você está neste diretório raiz.

🧰 Pré‑requisitos

Antes de começar, instale:

Ferramenta	Versão mínima recomendada
Docker	≥ 20.x
Kubectl	≥ 1.25
Minikube ou Kind	Qualquer versão estável
Terraform	≥ 1.6.0
Helm	≥ 3.x (para monitoramento opcional)

⚠️ Se faltar algum desses itens, instale antes — Kubernetes depende deles para funcionar localmente.

🚀 1) Clonar o Repositório

```
git clone https://github.com/orbite82/K8S-IA.git
cd K8S-IA
```

🐳 2) Build da Aplicação Docker

O app é uma API simples Python em app/. Vamos construir a imagem:

```
cd app
docker build -t my-local-app:latest .
docker images
cd ..
```

✔️ A tag my-local-app:latest é usada mais adiante nas configurações do Terraform.

🏗️ 3) Criar e Inicializar o Cluster Kubernetes

Você pode usar Minikube ou Kind:

🟢 Com Minikube (recomendado)
bash terraform/setup‑minikube.sh

Ou manualmente:

```
minikube start --profile=k8s-ia --driver=docker --kubernetes-version=v1.35.1
minikube addons enable storage‑provisioner --profile=k8s-ia
```

Verifique se está funcionando:

```
kubectl cluster-info
kubectl get nodes
```

⚙️ 4) Configurar o Provider do Terraform

No arquivo terraform/providers.tf, confirme:

```
provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "k8s-ia"
}
```

Isso garante que o Terraform fale com o contexto correto do Minikube.

📦 5) Recursos do Terraform

O arquivo terraform/main.tf define:

📌 Namespace
resource "kubernetes_namespace_v1" "app_ns" {
  metadata { name = var.namespace_name }
}
📌 Deployment da Aplicação

Container da API em Kubernetes:

resource "kubernetes_deployment_v1" "app" { ... }

Importante: image_pull_policy = "IfNotPresent" — para usar imagens locais do Docker sem erro ErrImagePull.

📌 Deployment PostgreSQL

Define o container Postgres:

resource "kubernetes_deployment_v1" "postgres" { ... }

Credenciais e database são passadas como variáveis.

📌 Serviços (ClusterIP)

Expõe os Deployments internamente:

resource "kubernetes_service_v1" "app_service" { ... }
resource "kubernetes_service_v1" "postgres_service" { ... }

▶️ 6) Rodar o Terraform

Inicialize e aplique:

```
cd terraform
terraform init -upgrade
terraform plan
terraform apply
```

Responda yes quando solicitado.
Você verá os recursos criados no cluster.

🧾 7) Validar Recursos

```
kubectl get namespaces
kubectl get deployments -n app-namespace
kubectl get pods -n app-namespace
kubectl get svc -n app-namespace
```

✔️ Confirme que tudo está Running.

🌐 8) Acessar a Aplicação

Redirecione a porta do serviço:

```
kubectl port-forward svc/my-app-service 8080:80 -n app-namespace
```

Abra no navegador:

http://localhost:8080

Você deve ver a aplicação respondendo.

🛢️ 9) Acessar o PostgreSQL

```
kubectl port-forward svc/postgres-service 5432:5432 -n app-namespace
```

Conecte via cliente PostgreSQL:

```
Host: localhost
Port: 5432
User: admin
Password: admin123
Database: mydb
```

(Credenciais de exemplo definidas nas variáveis Terraform)

📊 10) Monitoramento (Opcional)

Se tiver o Helm instalado, use o conteúdo de:

helm/prometheus-grafana.tf

para instalar Prometheus + Grafana.
Este passo não é obrigatório para validar a aplicação.

🧠 Dicas / Boas práticas

✔️ Se alterar arquivos *.tf:

```
terraform plan
terraform apply
```

✔️ Se mudar de cluster/contexto:

```
kubectl config use-context k8s-ia
```

✔️ Para remoção completa:

```
terraform destroy
```

✔️ Se houver conflito de recursos:

```
kubectl delete deployment my-app -n app-namespace
kubectl delete deployment postgres -n app-namespace
kubectl delete svc my-app-service -n app-namespace
kubectl delete svc postgres-service -n app-namespace
kubectl delete namespace app-namespace
```

👣 Próximos passos sugeridos

✔️ Automatizar isso em CI/CD (GitHub Actions / GitLab CI)
✔️ Adicionar Ingress para exposição externa
✔️ Adicionar Secrets/ConfigMaps com Kubernetes nativo
✔️ Criar PersistentVolumes para banco de dados
✔️ Testar com clusters reais (GKE, AKS, EKS)