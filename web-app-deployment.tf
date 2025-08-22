resource "kubernetes_deployment" "webapp" {
  metadata {
    name = "webapp"
    labels = {
      app = "webapp"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "webapp"
      }
    }

    template {
      metadata {
        labels = {
          app = "webapp"
        }
      }

      spec {
        container {
          name = "webapp"

          image = "cafecrunch/3c3b75e49fd9:latest"

          image_pull_policy = "Always"

          port {
            container_port = 8080
          }

          # Optional: Env vars
          env {
            name  = "MONGODB_URI"
            value = "mongodb://adminUser:your_password@ec2-44-251-106-62.us-west-2.compute.amazonaws.com:27017/go-mongodb?authSource=admin"
          }

          env {
            name  = "SECRET_KEY"
            value = "5d291c950a04312c4c40c885d1ede55c48340098ff5cf3f65a6527c0bfd776a6"
          }


          liveness_probe {
            http_get {
              path = "/health"
              port = 8080
            }
            initial_delay_seconds = 10
            period_seconds        = 5
          }
        }
      }
    }
  }
}
