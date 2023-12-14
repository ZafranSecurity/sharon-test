// Used to obtain the current AWS account ID
data "aws_caller_identity" "current" {}

// Used to obtain the current AWS region
data "aws_region" "current" {}
