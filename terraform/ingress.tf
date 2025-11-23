resource "kubernetes_ingress" "notesapp_ingress" {
  metadata {
    name      = "notesapp-ingress"
    namespace = kubernetes_namespace.notesapp.metadata[0].name
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
    }
  }

  spec {
    rule {
      host = "notes.<VM_IP>.nip.io"  # Remplacer <VM_IP> par l'IP de ta VM
      http {
        path {
          path = "/"
          backend {
            service_name = kubernetes_service.notesapp_frontend.metadata[0].name
            service_port = kubernetes_service.notesapp_frontend.spec[0].port[0].port
          }
        }
      }
    }
  }
}
