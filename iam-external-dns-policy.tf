resource "aws_iam_policy" "external-dns-policy" {
    name = "tf_${var.cluster_name}_EksNodeExternalDNS"
    path = "/"
    description = "Allows EKS nodes to modify Route53 to support ExternalDNS."
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
         "route53:ListHostedZones",
         "route53:ListResourceRecordSets"
      ],
     "Resource": ["*"]
    },
    {
      "Effect": "Allow",
      "Action": [
        "route53:ChangeResourceRecordSets"
      ],
      "Resource": ["*"]
    }
  ]
}
EOF
}
