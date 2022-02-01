module "nlb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"

  name = "my-nlb"

  load_balancer_type = "network"

  vpc_id  = "vpc-b8d13ade"
  subnets = ["subnet-977ea2f1", "subnet-6221ed2a", "subnet-7e65ee27"]

  # access_logs = {
  #   bucket = "new-bucket-test-test-test"
  # }

  target_groups = [
    {
      name_prefix      = "dd"
      backend_protocol = "TCP"
      backend_port     = 80
      target_type      = "instance"
    }
  ]


  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "TCP"
      target_group_index = 0
    }
  ]


}