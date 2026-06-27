variable "name" {
  description = "Name of the ASG"
  type        = string
}

variable "min_size" {
  description = "Minimum number of instances"
  type        = number
}

variable "max_size" {
  description = "Maximum number of instances"
  type        = number
}

variable "desired_capacity" {
  description = "Desired number of instances"
  type        = number
}

variable "vpc_zone_identifier" {
  description = "List of subnet IDs for ASG"
  type        = list(string)
}

variable "launch_template_id" {
  description = "Launch template ID"
  type        = string
}

variable "launch_template_version" {
  description = "Launch template version"
  type        = string
  default     = "$Latest"
}

variable "health_check_type" {
  description = "Health check type (EC2 or ELB)"
  type        = string
  default     = "EC2"
}

variable "health_check_grace_period" {
  description = "Health check grace period in seconds"
  type        = number
  default     = 300
}

variable "target_group_arns" {
  description = "List of target group ARNs"
  type        = list(string)
  default     = []
}

variable "termination_policies" {
  description = "List of termination policies"
  type        = list(string)
  default     = ["Default"]
}

variable "protect_from_scale_in" {
  description = "Protect instances from scale in"
  type        = bool
  default     = false
}

variable "capacity_rebalance" {
  description = "Enable capacity rebalance"
  type        = bool
  default     = false
}

variable "force_delete" {
  description = "Force delete ASG on destroy"
  type        = bool
  default     = false
}

variable "instance_refresh" {
  description = "Instance refresh settings"
  type = object({
    strategy = string
    preferences = object({
      instance_warmup        = number
      min_healthy_percentage = number
    })
  })
  default = null
}

variable "scaling_policies" {
  description = "List of scaling policies"
  type = list(object({
    name               = string
    adjustment_type    = string
    scaling_adjustment = number
    cooldown           = number
  }))
  default = []
}

variable "tags" {
  description = "Tags to apply to ASG and instances"
  type        = map(string)
  default     = {}
}
