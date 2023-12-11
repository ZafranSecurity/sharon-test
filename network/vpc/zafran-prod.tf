module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = "zafran-prod-vpc"
  cidr = "10.20.0.0/16"

  azs = [ "us-east-2a", "us-east-2b" ]
  private_subnets = [ "10.20.0.0/20", "10.20.16.0/20" ]
  public_subnets = [ "10.20.240.0/22", "10.20.244.0/22" ]

  reuse_nat_ips = true
  external_nat_ip_ids = slice(data.aws_eips.preallocated_eips.allocation_ids, 0, 2)

  enable_nat_gateway = true
  enable_vpn_gateway = false

  create_database_subnet_group = true
  create_database_subnet_route_table = true
  create_database_internet_gateway_route = true

  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Terraform = "true"
  }

  public_subnet_tags = {
    Tier = "public"
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    Tier = "private"
    "kubernetes.io/role/internal-elb" = "1"
  }
}
