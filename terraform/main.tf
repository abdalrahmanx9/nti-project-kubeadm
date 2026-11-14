module "vpc" {
  source       = "./modules/vpc"
  vpc_cidr     = var.vpc_cidr
  environment  = var.environment
  cluster_name = var.cluster_name
}

module "ecr" {
  source      = "./modules/ecr"
  environment = var.environment
}

module "secrets_manager" {
  source      = "./modules/secrets_manager"
  environment = var.environment
  db_username = var.db_username
  db_name     = var.db_name
}

module "kubeadm_cluster" {
  source               = "./modules/kubeadm_cluster"
  environment          = var.environment
  vpc_id               = module.vpc.vpc_id
  subnet_ids           = module.vpc.public_subnet_ids
  master_instance_type = var.master_instance_type
  worker_instance_type = var.worker_instance_type
  worker_count         = var.worker_count
  ssh_key_name         = var.ssh_key_name
  admin_cidr           = var.admin_cidr
}

module "rds" {
  source                     = "./modules/rds"
  environment                = var.environment
  vpc_id                     = module.vpc.vpc_id
  database_subnet_ids        = module.vpc.database_subnet_ids
  k8s_node_security_group_id = module.kubeadm_cluster.node_security_group_id
  db_name                    = var.db_name
  db_username                = var.db_username
  db_password                = module.secrets_manager.db_password
  db_instance_class          = var.db_instance_class
}
