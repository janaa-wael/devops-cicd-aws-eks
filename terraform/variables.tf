variable "aws_region" {
  type        = string
  description = "AWS region in which this project's resources will be managed."
  default     = "us-east-1"
}

variable "project_name" {
  type        = string
  description = "Project name applied to AWS resource tags."
  default     = "devops-cicd-aws-eks"
}

variable "vpc_cidr" {
  type        = string
  description = "IPv4 CIDR block for the project VPC."
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "IPv4 CIDR blocks for the public subnets."
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "IPv4 CIDR blocks for the private subnets."
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "allowed_admin_cidr" {
  type        = string
  description = "Single IPv4 address in /32 CIDR notation allowed to administer Jenkins and access the EKS public API."

  validation {
    condition     = can(cidrnetmask(var.allowed_admin_cidr)) && endswith(var.allowed_admin_cidr, "/32")
    error_message = "allowed_admin_cidr must be a valid single-host IPv4 CIDR ending in /32."
  }
}

variable "jenkins_instance_type" {
  type        = string
  description = "EC2 instance type for the Jenkins server."
  default     = "t3.small"
}

variable "jenkins_public_key_path" {
  type        = string
  description = "Local path to the public SSH key imported into AWS for Jenkins access."
}

variable "ecr_repository_name" {
  type        = string
  description = "Name of the private ECR repository that stores application images."
  default     = "devops-flask-app"
}

variable "eks_cluster_name" {
  type        = string
  description = "Name of the Amazon EKS cluster."
  default     = "devops-eks-cluster"
}

variable "eks_cluster_version" {
  type        = string
  description = "Kubernetes version used by the Amazon EKS control plane."
  default     = "1.35"
}

variable "eks_node_instance_type" {
  type        = string
  description = "EC2 instance type used by the EKS managed worker nodes."
  default     = "t3.small"
}
