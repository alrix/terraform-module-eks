resource "aws_eks_cluster" "eks-cluster" {
  name     = "tf-${var.cluster_name}"
  version  = var.eks_cluster_version
  role_arn = aws_iam_role.eks-cluster.arn
  enabled_cluster_log_types = split(",", var.cluster_log_types)

  vpc_config {
    subnet_ids = flatten([ 
      data.aws_subnet_ids.eks.ids 
    ])
    security_group_ids = [ aws_security_group.eks-cluster.id ]
    endpoint_private_access = true
    endpoint_public_access = false
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks-cluster-AmazonEKSServicePolicy
  ]
}
