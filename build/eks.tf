variable "eksClusterRoleName" {
  description = "eks_cluster_role_name"
  type        = string
  # default     = "eksClusterRoleBanjo"
}

variable "awsEks" {
  type = map
  # default = {
  #   "eks_name"  = "banjo_clusv2"
  #   "security_group_ids" = "sg-030afe75"
  #   # "subnet_ids" = ["subnet-6221ed2a", "subnet-7e65ee27", "subnet-977ea2f1"]
  # }
}
variable "eksSubnet" {
  type = list
  # default = ["subnet-6221ed2a", "subnet-7e65ee27", "subnet-977ea2f1"]
}

variable "eksNodesRoleName" {
  description = "eks_nodes_role_name"
  type        = string
  # default     = "eksClusterRoleNodeBanjo"
}

variable "eksNodeGroup" {
  type = map
  # default = {
    # "node_group_name"  = "banjo_node2"
    # # "subnet_ids" = ["subnet-6221ed2a", "subnet-7e65ee27", "subnet-977ea2f1"]
    # "instance_types" = "t3.medium"
    # "desired_size" = 1
    # "max_size" = 1
    # "min_size" = 1
  # }
}
variable "eksNodeSubnet"{
  type = list
  # default = ["subnet-6221ed2a", "subnet-7e65ee27", "subnet-977ea2f1"]
}




resource "aws_iam_role" "eks_cluster" {
  name = var.eksClusterRoleName   # Create cluster role name

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}


resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_eks_cluster" "aws_eks" {
  name     = var.awsEks["eks_name"]            # Create cluster name
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {                                  # Create cluster vpc
    security_group_ids = [var.awsEks["security_group_ids"]]
    # subnet_ids = [var.awsEks.subnet_ids[0], var.awsEks.subnet_ids[1], var.awsEks.subnet_ids[2]]
    subnet_ids = [var.eksSubnet[0], var.eksSubnet[1], var.eksSubnet[2]]
    # subnet_ids = [var.aws_eks["subnet_ids"]]
  }

#   tags = {
#     Name = "EKS_tuto"
#   }
}

resource "aws_iam_role" "eks_nodes" {
  name = var.eksNodesRoleName               # Create nodes role  name

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}


resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_eks_node_group" "node" {
  cluster_name    = aws_eks_cluster.aws_eks.name
  node_group_name = var.eksNodeGroup["node_group_name"]         # Create node group name
  node_role_arn   = aws_iam_role.eks_nodes.arn
  # subnet_ids      = ["<subnet-1>", "<subnet-2>", "<subnet-3>"]
  # subnet_ids      = [var.eksNodeGroup["subnet_ids"]]
  subnet_ids      = [var.eksNodeSubnet[0], var.eksNodeSubnet[1], var.eksNodeSubnet[2]]
  instance_types = [var.eksNodeGroup["instance_types"]]

  scaling_config {
    desired_size = var.eksNodeGroup["desired_size"]
    max_size     = var.eksNodeGroup["max_size"]
    min_size     = var.eksNodeGroup["min_size"]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}