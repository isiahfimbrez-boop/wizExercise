resource "aws_iam_role" "eks" {
  name = "myenv-myEKS-eks-cluster2" //using variables in case we create multiple eks CLUSTERS in a single account

  assume_role_policy = <<POLICY
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "eks.amazonaws.com"
          }
        }
      ]
    }
POLICY
}

resource "aws_iam_role_policy_attachment" "eks" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks.name
}

resource "aws_eks_cluster" "eks" {
  name     = "myenv-myEKS-eks-cluster2"
  version  = "1.33"               //for updates, all we need to do is update the version and run apply
  role_arn = aws_iam_role.eks.arn //attach IAM role to EKS cluster

  vpc_config {
    endpoint_private_access = false // disable private access to the EKS API endpoint
    endpoint_public_access  = true  //still have worker nodes in private subnets without public IPs 

    subnet_ids = [
      data.aws_subnet.private_subnet1.id,
      data.aws_subnet.private_subnet2.id
    ]
  }

  access_config {
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = true //explicitly enable in case its not in the future
  }

  depends_on = [aws_iam_role_policy_attachment.eks]
}
