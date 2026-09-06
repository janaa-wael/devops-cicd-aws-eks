output "vpc_id" {
  description = "ID of the project VPC."
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets."
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets."
  value       = aws_subnet.private[*].id
}

output "jenkins_instance_id" {
  description = "ID of the Jenkins EC2 instance."
  value       = aws_instance.jenkins.id
}

output "jenkins_public_ip" {
  description = "Public IPv4 address of the Jenkins EC2 instance."
  value       = aws_instance.jenkins.public_ip
}

output "jenkins_public_dns" {
  description = "Public DNS name of the Jenkins EC2 instance."
  value       = aws_instance.jenkins.public_dns
}

output "jenkins_iam_role_arn" {
  description = "ARN of the IAM role assumed by the Jenkins EC2 instance."
  value       = aws_iam_role.jenkins.arn
}

output "jenkins_instance_profile_name" {
  description = "Name of the instance profile associated with the Jenkins EC2 instance."
  value       = aws_iam_instance_profile.jenkins.name
}

output "ecr_repository_name" {
  description = "Name of the private ECR repository."
  value       = aws_ecr_repository.app.name
}

output "ecr_repository_url" {
  description = "URL used to push and pull images in the private ECR repository."
  value       = aws_ecr_repository.app.repository_url
}

output "ecr_repository_arn" {
  description = "ARN of the private ECR repository."
  value       = aws_ecr_repository.app.arn
}

output "eks_cluster_name" {
  description = "Name of the Amazon EKS cluster."
  value       = aws_eks_cluster.main.name
}

output "eks_cluster_arn" {
  description = "ARN of the Amazon EKS cluster."
  value       = aws_eks_cluster.main.arn
}

output "eks_cluster_endpoint" {
  description = "Kubernetes API endpoint of the Amazon EKS cluster."
  value       = aws_eks_cluster.main.endpoint
}

output "eks_node_group_name" {
  description = "Name of the EKS managed node group."
  value       = aws_eks_node_group.main.node_group_name
}

output "eks_node_group_arn" {
  description = "ARN of the EKS managed node group."
  value       = aws_eks_node_group.main.arn
}

output "eks_node_role_arn" {
  description = "ARN of the IAM role assumed by the EKS worker nodes."
  value       = aws_iam_role.eks_node.arn
}
