output "endpoint" { value = aws_eks_cluster.eks-cluster.endpoint }
output "kubeconfig-certificate-authority-data" { value = aws_eks_cluster.eks-cluster.certificate_authority.0.data }
output "node-iam-role" { value = aws_iam_role.eks-node.arn }
output "alb-ingress-sg" { value = aws_security_group.eks-alb-ingress.id }

output "config_map_aws_auth" { value = local.config_map_aws_auth }
locals {
  config_map_aws_auth = <<CONFIGMAPAWSAUTH

apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${aws_iam_role.eks-node.arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
  mapUsers: |
    - userarn: arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/USERNAME
      username: USERNAME
      groups:
        - system:masters
CONFIGMAPAWSAUTH

}

