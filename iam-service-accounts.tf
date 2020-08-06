# Role and attachment for alb-ingress-controller
data "aws_iam_policy_document" "alb-ingress-controller" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks-cluster.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:alb-ingress-controller"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks-cluster.arn]
      type        = "Federated"
    }
  }
}
resource "aws_iam_role" "alb-ingress-controller" {
  assume_role_policy = data.aws_iam_policy_document.alb-ingress-controller.json
  name = "tf_${var.cluster_name}_AlbIngressController"
}
resource "aws_iam_role_policy_attachment" "alb-ingress-controller" {
  policy_arn = aws_iam_policy.ingressController-iam-policy.arn
  role       = aws_iam_role.alb-ingress-controller.name
}

# Role and attachment for external dns
data "aws_iam_policy_document" "external-dns" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks-cluster.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:default:external-dns"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks-cluster.arn]
      type        = "Federated"
    }
  }
}
resource "aws_iam_role" "external-dns" {
  assume_role_policy = data.aws_iam_policy_document.external-dns.json
  name = "tf_${var.cluster_name}_ExternalDNS"
}
resource "aws_iam_role_policy_attachment" "external-dns" {
  policy_arn = aws_iam_policy.external-dns-policy.arn
  role       = aws_iam_role.external-dns.name
}

