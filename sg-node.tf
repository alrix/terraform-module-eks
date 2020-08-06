# Security group for the EKS Node
resource "aws_security_group" "eks-node" {
  name        = "tf-${var.cluster_name}-eks-node"
  description = "Security group for all nodes in the cluster"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = map(
   "Name", "tf-${var.cluster_name}-eks-node",
   "kubernetes.io/cluster/tf-${var.cluster_name}", "owned",
  )
}

resource "aws_security_group_rule" "eks-node-ssh" {
  cidr_blocks       = [ "0.0.0.0/0" ]
  description       = "Allow ssh access to eks cluster nodes"
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.eks-node.id
  to_port           = 22
  type              = "ingress"
}

resource "aws_security_group_rule" "eks-node-ingress-self" {
  description              = "Allow node to communicate with each other"
  security_group_id        = aws_security_group.eks-node.id
  source_security_group_id = aws_security_group.eks-node.id
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
  type                     = "ingress"
}

resource "aws_security_group_rule" "eks-node-ingress-cluster" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  security_group_id        = aws_security_group.eks-node.id
  source_security_group_id = aws_security_group.eks-cluster.id
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  type                     = "ingress"
}

resource "aws_security_group_rule" "eks-node-ingress-alb" {
  description              = "Allow worker Kubelets and pods to receive communication from ALBs"
  security_group_id        = aws_security_group.eks-node.id
  source_security_group_id = aws_security_group.eks-alb-ingress.id
  from_port                = 30000
  to_port                  = 32767
  protocol                 = "tcp"
  type                     = "ingress"
}
