variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the cluster is deployed"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for deploying the nodes"
  type        = list(string)
}

variable "master_instance_type" {
  description = "Instance type for the Kubeadm control plane"
  type        = string
  default     = "t3.medium"
}

variable "worker_instance_type" {
  description = "Instance type for the Kubeadm worker nodes"
  type        = string
  default     = "t3.medium"
}

variable "worker_count" {
  description = "Number of worker nodes to provision"
  type        = number
  default     = 2
}

variable "ssh_key_name" {
  description = "EC2 Key Pair name for SSH access"
  type        = string
  default     = ""
}

variable "admin_cidr" {
  description = "CIDR block permitted to access SSH and K8s API directly"
  type        = string
  default     = "0.0.0.0/0"
}
