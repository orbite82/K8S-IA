# ======================
# Variáveis do Cluster / Namespace
# ======================
variable "namespace_name" {
  description = "Nome do namespace onde a aplicação será implantada"
  type        = string
  default     = "app-namespace"
}

# ======================
# Variáveis da Aplicação
# ======================
variable "app_image" {
  description = "Imagem Docker da aplicação"
  type        = string
  default     = "my-local-app:latest"
}

variable "app_replicas" {
  description = "Número de réplicas da aplicação"
  type        = number
  default     = 2
}

variable "app_container_port" {
  description = "Porta do container da aplicação"
  type        = number
  default     = 8080
}

# ======================
# Variáveis do PostgreSQL
# ======================
variable "postgres_image" {
  description = "Imagem Docker do PostgreSQL"
  type        = string
  default     = "postgres:15-alpine"
}

variable "postgres_user" {
  description = "Usuário do PostgreSQL"
  type        = string
  default     = "admin"
}

variable "postgres_password" {
  description = "Senha do PostgreSQL"
  type        = string
  default     = "admin123"
}

variable "postgres_db" {
  description = "Banco de dados inicial do PostgreSQL"
  type        = string
  default     = "mydb"
}

variable "postgres_port" {
  description = "Porta do container PostgreSQL"
  type        = number
  default     = 5432
}

variable "postgres_replicas" {
  description = "Número de réplicas do PostgreSQL"
  type        = number
  default     = 1
}