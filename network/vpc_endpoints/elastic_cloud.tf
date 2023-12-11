// VPC Endpoint for the Elastic Cloud Service
// https://www.elastic.co/guide/en/cloud/current/ec-traffic-filtering-vpc.html
resource "aws_vpc_endpoint" "elastic_cloud_service_endpoint" {
  vpc_id = var.vpc_id
  service_name = "com.amazonaws.vpce.us-east-2.vpce-svc-02d187d2849ffb478"
  vpc_endpoint_type = "Interface"
  private_dns_enabled = false
  security_group_ids = [ aws_security_group.elastic_cloud_service_security_group.id ]
  subnet_ids = var.private_subnets
  tags = {
    Terraform = "true"
    Name = "elastic-cloud-service-endpoint"
  }
}

// Security Group attached to the service endpoint, allowing us to communicate with Elasticsearch
resource "aws_security_group" "elastic_cloud_service_security_group" {
  name = "elastic-cloud-service-security-group"
  vpc_id = var.vpc_id
  description = "Elastic Cloud Service Security Group"

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  ingress {
    from_port = 9243
    to_port = 9243
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  egress {
    from_port = 0
    protocol  = "tcp"
    to_port   = 0
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}

// Route53 Zone for the Elastic Cloud Service
resource "aws_route53_zone" "elastic_cloud_service_private_zone" {
  name = "vpce.us-east-2.aws.elastic-cloud.com" // taken from elastic.co
  comment = "Private Route53 Zone that provides private hostnames to Elastic Cloud Service via PrivateLink"
  vpc {
    vpc_id = var.vpc_id
    vpc_region = "us-east-2"
  }

  tags = {
    Terraform = "true"
    Name = "elastic-cloud-service-private-zone"
  }
}

// Wildcard record that maps all requests to the Elastic Cloud Service to the VPC Endpoint
resource "aws_route53_record" "elastic_cloud_service_wildcard_record" {
  zone_id = aws_route53_zone.elastic_cloud_service_private_zone.zone_id
  name = "*"
  type = "CNAME"
  ttl = "300"
  records = [ aws_vpc_endpoint.elastic_cloud_service_endpoint.dns_entry[0].dns_name ]
}
