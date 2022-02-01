#######################  eks  ######################################################################

eksClusterRoleName = "newrole-eksClusterRole"
awsEks = {
  eks_name  = "new-cluster"
  security_group_ids = "sg-030afe75"
  # subnet_ids = ["subnet-6221ed2a", "subnet-7e65ee27", "subnet-977ea2f1"]
}
eksSubnet = ["subnet-6221ed2a", "subnet-7e65ee27", "subnet-977ea2f1"]


eksNodesRoleName = "newnode-eksClusterRoleNode"
eksNodeGroup = {
  node_group_name  = "new_node"
  # subnet_ids = ["subnet-6221ed2a", "subnet-7e65ee27", "subnet-977ea2f1"]
  instance_types = "t3.medium"
  desired_size = 1
  max_size = 1
  min_size = 1
}
eksNodeSubnet = ["subnet-6221ed2a", "subnet-7e65ee27", "subnet-977ea2f1"]




#######################  nlb  ######################################################################

myNlb = {
  nlbName = "my-newnlb"
  lbType  = "network"
  vpc_id  = "vpc-b8d13ade"
}
nlbSubnet = ["subnet-6221ed2a", "subnet-7e65ee27", "subnet-977ea2f1"]

targetGroups = {
  namePrefix = "ddd"
  backendProtocol = "TCP"
  backendPort     = 80
  targetType      = "instance"
}

httpTcpListeners = {
  port               = 80
  protocol           = "TCP"
  targetGroupIndex   = 0
}
  
