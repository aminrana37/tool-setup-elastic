variable "ami_id" {
  default = "ami-09c813fb71547fc4f"
}

variable "zone_id" {
  default = "Z040862479ELHY34R71D"
}

variable "tools" {
  default = {

    elk-stack = {
      instance_type     = "i3.large"
      ports             = {
        logstash      = 5044
        kibana        = 80
      }
      root_block_device = 30
      iam_policy = {
        Action   = ["*"]
        Resource = []
      }
    }

  }
}

