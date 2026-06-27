# ASG Module

Creates an Auto Scaling Group with optional scaling policies.

## Usage

```hcl
module "asg" {
  source = "./modules/asg"

  name                = "my-app-asg"
  min_size            = 1
  max_size            = 5
  desired_capacity    = 2
  vpc_zone_identifier = ["subnet-1", "subnet-2"]
  launch_template_id  = "lt-123456"
  target_group_arns   = ["arn:aws:elasticloadbalancing:..."]

  tags = {
    Environment = "dev"
  }
}
```

## With Instance Refresh

```hcl
module "asg" {
  source = "./modules/asg"

  name                = "my-app-asg"
  min_size            = 2
  max_size            = 10
  desired_capacity    = 4
  vpc_zone_identifier = ["subnet-1", "subnet-2"]
  launch_template_id  = "lt-123456"

  instance_refresh = {
    strategy = "Rolling"
    preferences = {
      instance_warmup        = 300
      min_healthy_percentage = 50
    }
  }

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
| name | Name of the ASG | `string` | n/a | yes |
| min_size | Minimum number of instances | `number` | n/a | yes |
| max_size | Maximum number of instances | `number` | n/a | yes |
| desired_capacity | Desired number of instances | `number` | n/a | yes |
| vpc_zone_identifier | List of subnet IDs for ASG | `list(string)` | n/a | yes |
| launch_template_id | Launch template ID | `string` | n/a | yes |
| launch_template_version | Launch template version | `string` | `"$Latest"` | no |
| health_check_type | Health check type (EC2 or ELB) | `string` | `"EC2"` | no |
| health_check_grace_period | Health check grace period (seconds) | `number` | `300` | no |
| target_group_arns | List of target group ARNs | `list(string)` | `[]` | no |
| termination_policies | List of termination policies | `list(string)` | `["Default"]` | no |
| protect_from_scale_in | Protect instances from scale in | `bool` | `false` | no |
| capacity_rebalance | Enable capacity rebalance | `bool` | `false` | no |
| force_delete | Force delete ASG on destroy | `bool` | `false` | no |
| instance_refresh | Instance refresh settings | `object` | `null` | no |
| scaling_policies | List of scaling policies | `list(object)` | `[]` | no |
| tags | Tags to apply to ASG and instances | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| asg_arn | ARN of the ASG |
| asg_name | Name of the ASG |
| asg_id | ID of the ASG |
<!-- END_TF_DOCS -->

## Notes

- Use with a launch template module or create one separately.
- Set `health_check_type` to "ELB" when using with an ALB target group.
- Instance refresh enables rolling updates when launch template changes.
- Tags propagate to all instances launched by the ASG.
