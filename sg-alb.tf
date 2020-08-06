# Security group for the EKS Node
resource "aws_security_group" "eks-alb-ingress" {
  name        = "tf-${var.cluster_name}-alb-ingress"
  description = "Security group for ALB ingress rules"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = map(
   "Name", "tf-${var.cluster_name}-alb-ingress",
   "kubernetes.io/cluster/tf-${var.cluster_name}", "owned",
  )
}

# Following ports are defaults allowed into the ALBs

resource "aws_security_group_rule" "eks-alb-ingress-http-80" {
  cidr_blocks       = [ "0.0.0.0/0" ]
  description       = "ALB Ingress HTTP-80"
  from_port         = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.eks-alb-ingress.id
  to_port           = 80
  type              = "ingress"
}

resource "aws_security_group_rule" "eks-alb-ingress-https-443" {
  cidr_blocks       = [ "0.0.0.0/0" ]
  description       = "ALB Ingress HTTPS-443"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.eks-alb-ingress.id
  to_port           = 443
  type              = "ingress"
}

