data "aws_iam_policy_document" "jenkins_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "jenkins" {
  name               = "devops-jenkins-role"
  assume_role_policy = data.aws_iam_policy_document.jenkins_assume_role.json

  tags = {
    Name    = "devops-jenkins-role"
    Project = var.project_name
  }
}

resource "aws_iam_instance_profile" "jenkins" {
  name = "devops-jenkins-instance-profile"
  role = aws_iam_role.jenkins.name

  tags = {
    Name    = "devops-jenkins-instance-profile"
    Project = var.project_name
  }
}

data "aws_iam_policy_document" "jenkins_aws_access" {
  statement {
    sid       = "ECRAuthorization"
    effect    = "Allow"
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }

  statement {
    sid    = "ECRRepositoryPush"
    effect = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:CompleteLayerUpload",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart",
    ]
    resources = [aws_ecr_repository.app.arn]
  }

  statement {
    sid       = "EKSClusterDiscovery"
    effect    = "Allow"
    actions   = ["eks:DescribeCluster"]
    resources = [aws_eks_cluster.main.arn]
  }
}

resource "aws_iam_policy" "jenkins_aws_access" {
  name        = "devops-jenkins-aws-access"
  description = "Allows Jenkins to push to the application ECR repository and discover the EKS cluster."
  policy      = data.aws_iam_policy_document.jenkins_aws_access.json

  tags = {
    Name    = "devops-jenkins-aws-access"
    Project = var.project_name
  }
}

resource "aws_iam_role_policy_attachment" "jenkins_aws_access" {
  role       = aws_iam_role.jenkins.name
  policy_arn = aws_iam_policy.jenkins_aws_access.arn
}

resource "aws_eks_access_entry" "jenkins" {
  cluster_name  = aws_eks_cluster.main.name
  principal_arn = aws_iam_role.jenkins.arn
  type          = "STANDARD"

  tags = {
    Name    = "devops-jenkins-access"
    Project = var.project_name
  }
}

resource "aws_eks_access_policy_association" "jenkins_namespace_admin" {
  cluster_name  = aws_eks_cluster.main.name
  principal_arn = aws_iam_role.jenkins.arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"

  access_scope {
    type       = "namespace"
    namespaces = ["devops-app"]
  }

  depends_on = [aws_eks_access_entry.jenkins]
}
