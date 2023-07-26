terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0.0, <= 3.0.0" # Update this to the appropriate version range
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 1.0.0, <= 1.17.3" # Update this to the appropriate version range
    }
  }
}


provider "helm" {
  kubernetes {
    host = "https://kubernetes.default.svc"
    token = var.token
    cluster_ca_certificate = file(var.cluster_ca_certificate)
  }
}

variable "token" {
  type    = string
}

variable "cluster_ca_certificate" {
  type    = string
}

resource "helm_release" "argocd" {
  name  = "argocd"

  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  version          = "4.9.7"
  create_namespace = true

  values = [
    <<-EOT
    data:
      secretToken: ${var.token}

    users:
      - name: admin
        password: password
    EOT
  ]
}
