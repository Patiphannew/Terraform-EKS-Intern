variable "myNlb" {
  type = map
}

variable "nlbSubnet" {
  type = list
}

variable "targetGroups" {
  type = map
}

variable "httpTcpListeners" {
  type = map
}



module "nlb" {
  source  = "terraform-aws-modules/alb/aws"
  # source  = "./.terraform/modules/nlb"
  version = "~> 6.0"

  name = var.myNlb["nlbName"]                   # Create load balancer name

  load_balancer_type = var.myNlb["lbType"]      # Create load balancer type

  vpc_id  = var.myNlb["vpc_id"] 
  subnets = [var.nlbSubnet[0], var.nlbSubnet[1], var.nlbSubnet[2]]

  # access_logs = {
  #   bucket = "buckettestbanjo"
  # }

  target_groups = [                 # Create target groups
    {
      name_prefix      = var.targetGroups["namePrefix"]
      backend_protocol = var.targetGroups["backendProtocol"]
      backend_port     = var.targetGroups["backendPort"]
      # target_type      = "ip"
      target_type      = var.targetGroups["targetType"]
    }
  ]

#   https_listeners = [
#     {
#       port               = 443
#       protocol           = "TLS"
#       certificate_arn    = "arn:aws:iam::123456789012:server-certificate/test_cert-123456789012"
#       target_group_index = 0
#     }
#   ]

  http_tcp_listeners = [           # Create listeners
    {
      port               = var.httpTcpListeners["port"]
      protocol           = var.httpTcpListeners["protocol"]
      target_group_index = var.httpTcpListeners["targetGroupIndex"]
    }
  ]

#   tags = {
#     Environment = "Test"
#   }
}