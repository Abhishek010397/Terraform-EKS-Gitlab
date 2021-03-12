resource "aws_eks_cluster" "eks-cluster" {
  name     = eks-cluster
  role_arn = provide-your-role-arn
  version  = 1.19

  vpc_config {
    subnet_ids              = provide-eks_vpc_subnet_ids
    endpoint_private_access = provide-eks_endpoint_private_access
    endpoint_public_access  = provide-eks_endpoint_public_access
  }

  tags = {
    Name        = cluster-1
    Environment = provide-your-environment
  }
  timeouts {
    create = "40m"
  }

}
