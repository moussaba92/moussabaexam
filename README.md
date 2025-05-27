# 🛠️ Projet DevOps - CI/CD avec Jenkins, Docker, Helm & Kubernetes

Ce projet met en place un pipeline CI/CD complet avec Jenkins multibranch, DockerHub, Helm et Kubernetes (`kind`) pour déployer automatiquement une application sur différents environnements (dev, qa, staging, prod).

---

## 🔧 Technologies utilisées

- Jenkins (Multibranch Pipeline)
- Docker & DockerHub
- GitHub
- Helm v3
- Kubernetes (via kind)
- NGINX Ingress (pour accès local)

---

## 🚀 Environnements de déploiement

| Branche Git | Environnement K8s | Namespace Kubernetes |
|-------------|--------------------|----------------------|
| `develop`   | Développement       | `dev`                |
| `qa`        | Qualité             | `qa`                 |
| `staging`   | Préproduction       | `staging`            |
| `master`    | Production (manuel) | `prod`               |

---

## 📦 Structure du projet
