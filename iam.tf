resource "aws_iam_policy" "aws_load_balancer_controller" {
  name        = "AWSLoadBalancerControllerIAMPolicy-Terraform"
  description = "IAM policy for AWS Load Balancer Controller"
  policy      = file("${path.module}/policies/iam_policy2.json")
}
