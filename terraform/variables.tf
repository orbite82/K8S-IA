##########################################
# VARIABLES.TF - Variáveis do projeto
##########################################

# Namespace da aplicação
variable "app_namespace" {
  description = "Namespace da aplicação"
  type        = string
  default     = "app"
}

# Aplicação
variable "app_name" {
  description = "Nome da aplicação"
  type        = string
  default     = "my-app"
}

variable "app_image" {
  description = "Imagem da aplicação"
  type        = string
  default     = "nginx:latest"
}

variable "app_replicas" {
  description = "Número de réplicas da aplicação"
  type        = number
  default     = 1
}

variable "app_port" {
  description = "Porta exposta da aplicação"
  type        = number
  default     = 80
}

# Banco de dados PostgreSQL
variable "postgres_name" {
  description = "Nome do deployment PostgreSQL"
  type        = string
  default     = "postgres"
}

variable "postgres_image" {
  description = "Imagem do PostgreSQL"
  type        = string
  default     = "postgres:15"
}

variable "postgres_port" {
  description = "Porta do PostgreSQL"
  type        = number
  default     = 5432
}

variable "postgres_password" {
  description = "Senha do PostgreSQL"
  type        = string
  default     = "password123"
}

# Observabilidade (Helm)
variable "monitoring_namespace" {
  description = "Namespace para Prometheus e Grafana"
  type        = string
  default     = "monitoring"
}

variable "grafana_admin_user" {
  description = "Usuário admin do Grafana"
  type        = string
  default     = "admin"
}

variable "grafana_admin_password" {
  description = "Senha admin do Grafana"
  type        = string
  default     = "admin"
}