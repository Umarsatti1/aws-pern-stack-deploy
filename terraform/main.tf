module "vpc" {
  source = "./modules/vpc"
}

module "rds" {
  source             = "./modules/rds"
  name               = "pern-rds"
  db_name            = "perndb"
  db_username        = "pernadmin"
  db_password        = "admin123"
  private_subnet_ids = module.vpc.private_subnets
  vpc_id             = module.vpc.vpc_id
  rds_sg_id          = module.sg.rds_sg_id
  allowed_cidr_blocks = [module.sg.ecs_sg_id] # or fixed IP/CIDR for testing
}

module "ssm" {
  source        = "./modules/ssm"
  prefix        = "/pernapp"
  db_username   = module.rds.db_username
  db_password   = module.rds.db_password
  db_name       = module.rds.db_name
  db_host       = module.rds.rds_endpoint
  db_port       = module.rds.db_port
}

module "iam" {
  source      = "./modules/iam"
  region      = var.region
  account_id  = var.account_id
  role_name   = "Tf-ECS-TaskExecutionRole"
  ssm_prefix  = "/pern"
}

module "ecs" {
  source             = "./modules/ecs"
  app_name           = "pern-app"
  cluster_name       = "pern-cluster"
  server_image       = "${var.account_id}.dkr.ecr.us-east-1.amazonaws.com/pern-backend:latest"
  client_image       = "${var.account_id}.dkr.ecr.us-east-1.amazonaws.com/pern-frontend:latest"
  region             = var.region
  execution_role_arn = module.iam.ecs_task_role_arn
  private_subnet_ids = module.vpc.private_subnets
  ecs_sg_id          = module.sg.ecs_sg_id
  service_sg_id      = module.sg.ecs_sg_id
  target_group_arn   = module.alb.frontend_target_group_arn
}

module "sg" {
  source  = "./modules/sg"
  project = "pern"
  vpc_id  = module.vpc.vpc_id
  rds_port = 5432
}

module "ecr" {
  source  = "./modules/ecr"
  project = "pern"
}

module "alb" {
  source              = "./modules/alb"
  name                = "pern"
  app_name            = "pern-app"
  vpc_id              = module.vpc.vpc_id
  public_subnet_ids   = module.vpc.public_subnets
  security_group_ids  = [module.sg.alb_sg_id]
  target_port         = 3000
}