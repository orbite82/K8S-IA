# ======================
# Namespace
# ======================
variable "namespace_name" {
  description = "Nome do namespace onde a aplicação e PostgreSQL serão criados"
  type        = string
  default     = "app-namespace"
}

# ======================
# Aplicação Python
# ======================
variable "app_image" {
  description = "Imagem Docker da aplicação Python"
  type        = string
  default     = "my-local-app:latest"
}

variable "app_replicas" {
  description = "Número de réplicas do deployment da aplicação"
  type        = number
  default     = 2
}

variable "app_container_port" {
  description = "Porta do container da aplicação Flask"
  type        = number
  default     = 5000
}

# ======================
# PostgreSQL
# ======================
variable "postgres_image" {
  description = "Imagem Docker do PostgreSQL"
  type        = string
  default     = "postgres:15-alpine"
}

variable "postgres_replicas" {
  description = "Número de réplicas do deployment PostgreSQL"
  type        = number
  default     = 1
}

variable "postgres_port" {
  description = "Porta do container PostgreSQL"
  type        = number
  default     = 5432
}

variable "postgres_user" {
  description = "Usuário do banco PostgreSQL"
  type        = string
  default     = "admin"
}

variable "postgres_password" {
  description = "Senha do banco PostgreSQL"
  type        = string
  default     = "admin123"
}

variable "postgres_db" {
  description = "Nome do banco de dados PostgreSQL"
  type        = string
  default     = "mydb"
}