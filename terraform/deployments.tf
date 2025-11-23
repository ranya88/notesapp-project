resource "kubernetes_deployment" "notesapp_frontend" {
  metadata {
    name      = "notesapp-frontend"
    namespace = kubernetes_namespace.notesapp.metadata[0].name
    labels = {
      app = "notesapp-frontend"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "notesapp-frontend"
      }
    }
    template {
      metadata {
        labels = {
          app = "notesapp-frontend"
        }
      }
      spec {
        container {
          name  = "notesapp-frontend"
          image = "nginx:alpine"
          ports {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "notesapp_api" {
  metadata {
    name      = "notesapp-api"
    namespace = kubernetes_namespace.notesapp.metadata[0].name
    labels = {
      app = "notesapp-api"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "notesapp-api"
      }
    }
    template {
      metadata {
        labels = {
          app = "notesapp-api"
        }
      }
      spec {
        container {
          name  = "notesapp-api"
          image = "flask_api_image"  # Remplacez ceci par l'image Docker Flask réelle
          ports {
            container_port = 5000
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "notesapp_db" {
  metadata {
    name      = "notesapp-db"
    namespace = kubernetes_namespace.notesapp.metadata[0].name
    labels = {
      app = "notesapp-db"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "notesapp-db"
      }
    }
    template {
      metadata {
        labels = {
          app = "notesapp-db"
        }
      }
      spec {
        container {
          name  = "notesapp-db"
          image = "postgres:15-alpine"
          env {
            name  = "POSTGRES_DB"
            value = "notes"
          }
          env {
            name  = "POSTGRES_USER"
            value = "postgres"
          }
          env {
            name  = "POSTGRES_PASSWORD"
            value = "postgres"
          }
          ports {
            container_port = 5432
          }
        }
      }
    }
  }
}
