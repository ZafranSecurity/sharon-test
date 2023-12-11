resource "aws_vpc_endpoint" "s3" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.s3"
  vpc_endpoint_type = "Interface"
  subnet_ids = var.private_subnets
  tags = {
    Terraform = "true"
    Name = "s3-vpc-endpoint"
  }
}