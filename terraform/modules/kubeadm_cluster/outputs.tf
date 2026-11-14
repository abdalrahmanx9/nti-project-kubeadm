output "control_plane_public_ip" {
  description = "Public Elastic IP of Kubeadm Control Plane"
  value       = aws_eip.control_plane_eip.public_ip
}

output "control_plane_private_ip" {
  description = "Private IP of Kubeadm Control Plane"
  value       = aws_instance.control_plane.private_ip
}

output "control_plane_id" {
  description = "Instance ID of Control Plane"
  value       = aws_instance.control_plane.id
}

output "worker_public_ips" {
  description = "Public IPs of Kubeadm Worker Nodes"
  value       = aws_instance.workers[*].public_ip
}

output "worker_private_ips" {
  description = "Private IPs of Kubeadm Worker Nodes"
  value       = aws_instance.workers[*].private_ip
}

output "worker_ids" {
  description = "Instance IDs of Worker Nodes"
  value       = aws_instance.workers[*].id
}

output "node_security_group_id" {
  description = "Security Group ID of the Kubeadm cluster nodes"
  value       = aws_security_group.k8s_nodes.id
}
