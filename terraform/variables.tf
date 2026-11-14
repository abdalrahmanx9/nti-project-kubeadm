variable "aws_region" {
  description = "AWS deployment region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment environment name"
  type        = string
  default     = "production"
}

variable "vpc_cidr" {
  description = "Base CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "cluster_name" {
  description = "Name of the Kubeadm Kubernetes Cluster"
  type        = string
  default     = "nti-devops-kubeadm"
}

variable "master_instance_type" {
  description = "Instance type for the Kubeadm Control Plane"
  type        = string
  default     = "t3.small"
}

variable "worker_instance_type" {
  description = "Instance type for the Kubeadm Worker Nodes"
  type        = string
  default     = "t3.small"
}

variable "worker_count" {
  description = "Number of Kubeadm Worker Nodes"
  type        = number
  default     = 2
}

variable "ssh_key_name" {
  description = "AWS EC2 Key Pair name for SSH access to cluster nodes"
  type        = string
  default     = ""
}

variable "admin_cidr" {
  description = "Permitted CIDR block for administrative SSH and K8s API access"
  type        = string
  default     = "0.0.0.0/0"
}

variable "db_name" {
  description = "Database name for PostgreSQL RDS"
  type        = string
  default     = "ntiapp"
}

variable "db_username" {
  description = "Master username for PostgreSQL RDS"
  type        = string
  default     = "dbadmin"
}

variable "db_instance_class" {
  description = "Instance class for RDS PostgreSQL instance"
  type        = string
  default     = "db.t3.micro"
}
