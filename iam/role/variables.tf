variable "name" {
  description = "Name of the IAM role"
  type        = string
}

variable "description" {
  description = "Description of the IAM role"
  type        = string
  default     = ""
}

variable "trusted_entity_type" {
  description = "Type of trusted entity: Service, AWS, Federated"
  type        = string
  default     = "Service"
}

variable "trusted_identifiers" {
  description = "List of identifiers for the trusted entity (e.g., ec2.amazonaws.com, account ARNs)"
  type        = list(string)
}

variable "policy_arns" {
  description = "List of IAM policy ARNs to attach to the role"
  type        = list(string)
  default     = []
}

variable "inline_policies" {
  description = "Map of inline policy names to policy documents"
  type        = map(string)
  default     = {}
}

variable "max_session_duration" {
  description = "Maximum session duration in seconds (3600-43200)"
  type        = number
  default     = 3600
}

variable "tags" {
  description = "Tags to apply to the role"
  type        = map(string)
  default     = {}
}
