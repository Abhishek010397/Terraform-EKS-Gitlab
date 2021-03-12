resource "aws_eks_node_group" "eks-node-group" {
  cluster_name    = aws_eks_cluster.eks-cluster.name
  node_group_name = ng-1
  instance_types  = t2.xlarge
  node_role_arn   = your-eks_node_group_role_arn
  subnet_ids      = your-eks_node_group_subnet_ids

  scaling_config {
    desired_size = 3
    max_size     = 4
    min_size     = 3
  }

  remote_access {
    ec2_ssh_key               = your-eks_node_group_remote_access_key
    source_security_group_ids = your-eks_security_group_ids
  }

}
