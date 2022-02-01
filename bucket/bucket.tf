module "s3_bucket_for_logs" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "new-myawsbucket"
  acl    = "log-delivery-write"

  # Allow deletion of non-empty bucket
  force_destroy = true
  #   attach_elb_log_delivery_policy = true  # Required for ALB logs
  attach_lb_log_delivery_policy = true # Required for ALB/NLB logs
}
