// Used to obtain the current AWS account ID
data "aws_caller_identity" "current" {}

// Used to obtain the current AWS region
data "aws_region" "current" {}

data "aws_eips" "preallocated_eips" {
  filter {
    name   = "public-ip"
    values = [
      "3.145.244.32",
      "3.145.244.33",
      "3.145.244.34",
      "3.145.244.35",
      "3.145.244.36",
      "3.145.244.37",
      "3.145.244.38",
      "3.145.244.39"
    ]
  }
}
