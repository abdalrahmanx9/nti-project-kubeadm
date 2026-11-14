# nti-project-kubeadm

Self-managed Kubernetes (kubeadm v1.31) cluster on AWS EC2, provisioned via Terraform and Ansible, with CI/CD driven entirely by GitHub Actions.

## Architecture

```
Developer Git Push / PR
          |
          v
+-------------------------------------------------------------+
| GitHub Actions                                              |
| - Lint (ruff) & tests (pytest)                              |
| - Security scan (trivy)                                     |
| - Docker build & push to AWS ECR                            |
| - Terraform plan & apply with environment protection        |
+-------------------------------------------------------------+
          |
          v
+-------------------------------------------------------------+
| AWS Infrastructure (Terraform)                              |
| - VPC (public, private, db subnets across 2 AZs)            |
| - 1x Control plane (t3.small + Elastic IP)                  |
| - 2x Worker nodes (t3.small)                                |
| - PostgreSQL RDS in isolated DB subnets                     |
| - ECR private repository                                    |
| - Secrets Manager (database credentials)                    |
+-------------------------------------------------------------+
          |
          v
+-------------------------------------------------------------+
| Kubernetes Cluster (Ansible / kubeadm)                      |
| - containerd runtime                                        |
| - Calico CNI                                                |
| - Ingress-Nginx controller                                  |
| - ArgoCD for pull-based GitOps sync                         |
| - kube-prometheus-stack (monitoring & alerting)             |
+-------------------------------------------------------------+
```

## Platform Endpoints

| Service | Target | Access |
| :--- | :--- | :--- |
| Application | `http://<WORKER_IP>:30080` | Public / NodePort |
| Swagger Docs | `http://<WORKER_IP>:30080/docs` | Public UI |
| ArgoCD | `kubectl port-forward svc/argocd-server -n argocd 8081:443` | `https://localhost:8081` |
| Grafana | `kubectl port-forward svc/prometheus-grafana 3000:80 -n monitoring` | `http://localhost:3000` |
| Prometheus | `kubectl port-forward svc/prometheus-kube-prometheus-prometheus 9090:9090 -n monitoring` | `http://localhost:9090` |
| Alertmanager | `kubectl port-forward svc/prometheus-kube-prometheus-alertmanager 9093:9093 -n monitoring` | `http://localhost:9093` |
| Control Plane SSH | `ssh -i ~/.ssh/nti-devops-key.pem ubuntu@<CONTROL_PLANE_IP>` | Direct SSH |
| Worker Node SSH | `ssh -i ~/.ssh/nti-devops-key.pem ubuntu@<WORKER_IP>` | Direct SSH |

## Repository Layout

```
.
├── .github/workflows/
│   ├── app-ci.yml              # Lint, test, security scan, docker build/push
│   └── terraform.yml           # Terraform plan/apply and kubeadm ansible trigger
├── ansible/
│   ├── kubeadm_setup.yml       # Bootstrap containerd, k8s packages, calico, ingress
│   ├── inventory.example.ini   # Host definitions template
│   └── run-playbook.ps1        # Local docker-based playbook runner
├── app/                        # FastAPI application source & test suite
├── charts/nti-app/             # Helm chart (configured for NodePort 30080)
├── k8s/                        # ArgoCD application manifest and network policies
├── monitoring/                 # Prometheus rules, Alertmanager config, Grafana dashboard
└── terraform/                  # Root configuration and modules
    └── modules/
        ├── ecr/                # Container registry
        ├── kubeadm_cluster/    # EC2 instances, security groups, IAM profile
        ├── rds/                # PostgreSQL instance
        ├── secrets_manager/    # Database credentials
        └── vpc/                # Multi-AZ networking
```

## Deployment

### Prerequisites
- GitHub repository secrets configured:
  - `AWS_ACCESS_KEY_ID`
  - `AWS_SECRET_ACCESS_KEY`
  - `SSH_PRIVATE_KEY` (PEM content for EC2 access)
- GitHub Environment `production` configured if manual approval is required before apply.

### Deploy Infrastructure & Cluster via GitHub CLI
```bash
gh workflow run terraform.yml -f action=plan-and-apply -f bootstrap_cluster=true
gh run watch
```

### Manual / Local Deployment (Optional)
If running outside of GitHub Actions:

1. **Terraform**:
   ```bash
   cd terraform
   cp terraform.tfvars.example terraform.tfvars
   terraform init
   terraform plan -out=tfplan
   terraform apply tfplan
   ```

2. **Ansible**:
   ```bash
   cd ../ansible
   cp inventory.example.ini inventory.ini
   # Add your control plane and worker public IPs from terraform output
   ansible-playbook -i inventory.ini kubeadm_setup.yml
   ```
