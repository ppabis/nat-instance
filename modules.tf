module "test-vpc" {
  source = "./Test-VPC"
  region = var.region
}

module "nat" {
  source          = "./NAT"
  vpc             = module.test-vpc.vpc
  public_subnet   = module.test-vpc.public-subnet
  private_subnet  = module.test-vpc.private-subnets
  route_tables    = module.test-vpc.private-route-tables
  elastic_ip      = true
  additional_cidr = [module.test-vpc.private-subnet-cidrs[2]]   // Allow instance 3
  additional_sg   = [aws_security_group.Test-Security-Group.id] // Allow instance 1
}

module "test-instances" {
  source  = "./Test-Instances"
  vpc     = module.test-vpc.vpc
  subnets = module.test-vpc.private-subnets
  security_groups = [
    aws_security_group.Test-Security-Group.id, // Instance 1 will be allowed via SG
    module.nat.security_group_id,              // Instance 2 will use the same SG as the NAT
    null                                       // Instance 3 will be allowed via CIDR
  ]
}

module "test-ssm" {
  source = "./Test-SSM"
}

output "public-ip" {
  value = module.nat.public-nat-ip
}
