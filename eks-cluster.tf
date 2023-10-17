# Create AWS EKS Cluster
resource "aws_eks_cluster" "eks_cluster" {
  name = "${local.name}-${var.cluster_name}" # defined under local-values.tf

  /* name = local.eks_cluster_name 
  
  alternative for naming resource defined under local-values.tf */

  role_arn = aws_iam_role.eks_master_role.arn # defined under eks-cluster.tf
  version  = var.cluster_version              # defined under variable-kubernetes-cluster.tf

  vpc_config {
    subnet_ids              = module.vpc.public_subnets                # defined under vpc-output.tf + vpc-module.tf  + variable-vpc.tf
    endpoint_private_access = var.cluster_endpoint_private_access      # defined under variables-kubernetes-cluster.tf
    endpoint_public_access  = var.cluster_endpoint_public_access       # defined under variables-kubernetes-cluster.tf
    public_access_cidrs     = var.cluster_endpoint_public_access_cidrs # defined under variables-kubernetes-cluster.tf
  }

  kubernetes_network_config {
    service_ipv4_cidr = var.cluster_service_ipv4_cidr # defined under variables-kubernetes-cluster.tf
  }

  # Enable EKS Cluster Control Plane Logging
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.eks-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks-AmazonEKSVPCResourceController,
  ]
}
