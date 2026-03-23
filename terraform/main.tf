##########################################
# MAIN.TF - Ambiente local Kind + App + DB
##########################################

# Namespace da aplicação
resource "kubernetes_namespace" "app_ns" {
  metadata {
    name = "app"
  }
}

# ==========================
# Deployment da aplicação
# ==========================
resource "kubernetes_deployment" "app" {
  metadata {
    name      = "my-app"
    namespace = kubernetes_namespace.app_ns.metadata[0].name
  }

  spec {
    replicas = 1

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
          image = "my-local-app:latest"
          ports {
            container_port = 80
          }
        }
      }
    }
  }
}

# Service da aplicação
resource "kubernetes_service" "app_svc" {
  metadata {
    name      = "my-app-svc"
    namespace = kubernetes_namespace.app_ns.metadata[0].name
  }

  spec {
    selector = {
      app = "my-app"
    }
    port {
      port        = 80
      target_port = 80
    }
    type = "NodePort"
  }
}

# ==========================
# Deployment PostgreSQL
# ==========================
resource "kubernetes_deployment" "postgres" {
  metadata {
    name      = "postgres"
    namespace = kubernetes_namespace.app_ns.metadata[0].name
  }

  spec {
    replicas = 1

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
          image = "postgres:15"
          env {
            name  = "POSTGRES_PASSWORD"
            value = "password123"
          }
          ports {
            container_port = 5432
          }
        }
      }
    }
  }
}

# Service PostgreSQL
resource "kubernetes_service" "postgres_svc" {
  metadata {
    name      = "postgres-svc"
    namespace = kubernetes_namespace.app_ns.metadata[0].name
  }

  spec {
    selector = {
      app = "postgres"
    }
    port {
      port        = 5432
      target_port = 5432
    }
    type = "ClusterIP"
  }
}