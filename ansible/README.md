# Ansible Automation

Playbooks for provisioning the Kubeadm cluster and system telemetry on Ubuntu 24.04/22.04 LTS.

## Playbooks

- `kubeadm_setup.yml`: Configures kernel modules, containerd runtime, official k8s apt repository, installs kubelet/kubeadm/kubectl (v1.31), initializes control plane, installs Calico CNI, installs Ingress-Nginx, and joins worker nodes.
- `cloudwatch_agent.yml`: Deploys AWS CloudWatch Agent for host metrics.

## Usage

1. Copy `inventory.example.ini` to `inventory.ini` and set host IPs from Terraform outputs:
   ```bash
   cp inventory.example.ini inventory.ini
   ```

2. Run directly on Linux/WSL/macOS:
   ```bash
   ansible-playbook -i inventory.ini kubeadm_setup.yml
   ```

3. Or run using Docker on Windows:
   ```powershell
   .\run-playbook.ps1 kubeadm_setup.yml
   ```
