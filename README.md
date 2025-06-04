# Project04 - CI/CD with Jenkins, Docker, and AWS EKS

A simple CI/CD pipeline to build a Docker image, push it to DockerHub, and deploy it to AWS EKS using Jenkins.

---

## ✅ Prerequisites

- AWS EKS cluster (created via `eksctl`)
- `kubectl` and `awscli` installed on Jenkins server
- Jenkins running with:

  - **AWS credentials**:
    - Add as **Username and Password** credential (ID: `aws-creds`)
    - Username = Access Key ID
    - Password = Secret Access Key

  - **DockerHub credentials**:
    - Add as **Secret Text** credential (ID: `dockerhub`)
    - Value = DockerHub password or access token

  - **Slack credentials (optional)**:
    - Add as **Secret Text** credential (ID: `slack`)

---

## 📦 Project Files

- `Dockerfile`: Nginx with custom static content
- `index.html`: Static page
- `deployment.yml`: Kubernetes Deployment + LoadBalancer Service
- pipeline.sh: CI/CD Pipeline

---

## 🚀 Deploy

Once the pipeline runs, access the app using the LoadBalancer URL:

```bash
kubectl get svc
