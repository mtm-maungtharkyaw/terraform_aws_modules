resource "aws_autoscaling_group" "this" {
  name                      = var.name
  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  vpc_zone_identifier       = var.vpc_zone_identifier
  target_group_arns         = var.target_group_arns
  health_check_type         = var.health_check_type
  health_check_grace_period = var.health_check_grace_period
  termination_policies      = var.termination_policies
  protect_from_scale_in     = var.protect_from_scale_in
  capacity_rebalance        = var.capacity_rebalance
  force_delete              = var.force_delete

  launch_template {
    id      = var.launch_template_id
    version = var.launch_template_version
  }

  dynamic "instance_refresh" {
    for_each = var.instance_refresh != null ? [var.instance_refresh] : []
    content {
      strategy = instance_refresh.value.strategy
      preferences {
        instance_warmup        = instance_refresh.value.preferences.instance_warmup
        min_healthy_percentage = instance_refresh.value.preferences.min_healthy_percentage
      }
    }
  }

  dynamic "tag" {
    for_each = merge(
      var.tags,
      { Name = var.name }
    )
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

resource "aws_autoscaling_policy" "this" {
  count = length(var.scaling_policies)

  name                   = var.scaling_policies[count.index].name
  autoscaling_group_name = aws_autoscaling_group.this.name
  adjustment_type        = var.scaling_policies[count.index].adjustment_type
  scaling_adjustment     = var.scaling_policies[count.index].scaling_adjustment
  cooldown               = var.scaling_policies[count.index].cooldown
}
