# ALB Module

Creates an Application Load Balancer with target group and listeners.

## Usage

```hcl
module "alb" {
  source = "./modules/alb"

  name                = "my-app-alb"
  vpc_id              = "vpc-123456"
  subnet_ids          = ["subnet-1", "subnet-2"]
  security_group_ids  = ["sg-123456"]
  target_group_name   = "my-app-tg"

  tags = {
    Environment = "dev"
  }
}
```

## HTTPS Example

```hcl
module "alb" {
  source = "./modules/alb"

  name                  = "my-app-alb"
  vpc_id                = "vpc-123456"
  subnet_ids            = ["subnet-1", "subnet-2"]
  security_group_ids    = ["sg-123456"]
  target_group_name     = "my-app-tg"
  
  create_http_listener  = false
  create_https_listener = true
  certificate_arn       = "arn:aws:acm:us-east-1:123:certificate/abc"

  tags = {
    Environment = "prod"
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 4.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name of the ALB | `string` | n/a | yes |
| vpc_id | VPC ID for the target group | `string` | n/a | yes |
| subnet_ids | List of subnet IDs for the ALB | `list(string)` | n/a | yes |
| security_group_ids | List of security group IDs for the ALB | `list(string)` | n/a | yes |
| target_group_name | Name of the target group | `string` | n/a | yes |
| internal | Whether the ALB is internal | `bool` | `false` | no |
| enable_deletion_protection | Enable deletion protection | `bool` | `false` | no |
| target_group_port | Port for the target group | `number` | `80` | no |
| target_group_protocol | Protocol for the target group | `string` | `"HTTP"` | no |
| create_http_listener | Create HTTP listener on port 80 | `bool` | `true` | no |
| create_https_listener | Create HTTPS listener on port 443 | `bool` | `false` | no |
| ssl_policy | SSL policy for HTTPS listener | `string` | `"ELBSecurityPolicy-2016-08"` | no |
| certificate_arn | ACM certificate ARN for HTTPS listener | `string` | `null` | no |
| health_check_enabled | Enable health check | `bool` | `true` | no |
| health_check_healthy_threshold | Consecutive checks before healthy | `number` | `3` | no |
| health_check_interval | Interval between health checks (seconds) | `number` | `30` | no |
| health_check_matcher | HTTP response code for success | `string` | `"200"` | no |
| health_check_path | Path for health check | `string` | `"/"` | no |
| health_check_port | Port for health check | `string` | `"traffic-port"` | no |
| health_check_protocol | Protocol for health check | `string` | `"HTTP"` | no |
| health_check_timeout | Timeout for health check (seconds) | `number` | `5` | no |
| health_check_unhealthy_threshold | Consecutive failures before unhealthy | `number` | `3` | no |
| tags | Tags to apply to resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| alb_arn | ARN of the ALB |
| alb_dns_name | DNS name of the ALB |
| alb_zone_id | Zone ID of the ALB |
| target_group_arn | ARN of the target group |
| http_listener_arn | ARN of the HTTP listener |
| https_listener_arn | ARN of the HTTPS listener |
<!-- END_TF_DOCS -->

## Notes

- The ALB is created in the specified subnets. For high availability, provide at least two subnets in different AZs.
- To use HTTPS, you must provide a valid ACM certificate ARN.
- The target group is created with HTTP health checks by default. Customize the health check settings as needed.
- Security groups should allow inbound traffic on the listener ports (80/443).
