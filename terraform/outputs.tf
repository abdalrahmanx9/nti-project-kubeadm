output "vpc_id" {
  value = module.vpc.vpc_id
}

output "control_plane_public_ip" {
  value = module.kubeadm_cluster.control_plane_public_ip
}

output "control_plane_private_ip" {
  value = module.kubeadm_cluster.control_plane_private_ip
}

output "worker_public_ips" {
  value = module.kubeadm_cluster.worker_public_ips
}

output "worker_private_ips" {
  value = module.kubeadm_cluster.worker_private_ips
}

output "node_security_group_id" {
  value = module.kubeadm_cluster.node_security_group_id
}

output "ecr_repository_url" {
  value = module.ecr.repository_url
}

output "rds_endpoint" {
  value = module.rds.endpoint
}

output "rds_address" {
  value = module.rds.address
}

output "rds_secret_arn" {
  value = module.secrets_manager.secret_arn
}
