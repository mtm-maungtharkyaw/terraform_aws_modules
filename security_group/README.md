# Security Group Module

Creates an AWS Security Group with configurable ingress and egress rules.

## Features

- Dynamic ingress and egress rules
- Support for CIDR blocks, IPv6, security group references, and self-referencing
- Default egress rule (allow all outbound)
- Tagging support

## Usage

### Basic Example - Web Server

```hcl
module "web_sg" {
  source = "./modules/security_group"

  name        = "web-server-sg"
  description = "Security group for web server"
  vpc_id      = "vpc-12345678"

  ingress_rules = [
    {
      description = "Allow HTTP"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Allow HTTPS"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  tags = {
    Environment = "production"
    Project     = "web-app"
  }
}
```

### Database Security Group

```hcl
module "db_sg" {
  source = "./modules/security_group"

  name        = "database-sg"
  description = "Security group for database"
  vpc_id      = "vpc-12345678"

  ingress_rules = [
    {
      description     = "Allow MySQL from web servers"
      from_port       = 3306
      to_port         = 3306
      protocol        = "tcp"
      security_groups = [module.web_sg.security_group_id]
    }
  ]

  tags = {
    Environment = "production"
    Project     = "web-app"
  }
}
```

### SSH Access (Restricted)

```hcl
module "ssh_sg" {
  source = "./modules/security_group"

  name        = "ssh-access-sg"
  description = "Security group for SSH access"
  vpc_id      = "vpc-12345678"

  ingress_rules = [
    {
      description = "Allow SSH from office"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["203.0.113.0/24"]  # Your office IP
    }
  ]

  tags = {
    Environment = "production"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| name | Name of the security group | `string` | - | yes |
| description | Description of the security group | `string` | "Managed by Terraform" | no |
| vpc_id | VPC ID where the security group will be created | `string` | - | yes |
| ingress_rules | List of ingress rules | `list(object)` | `[]` | no |
| egress_rules | List of egress rules | `list(object)` | Allow all outbound | no |
| tags | Tags to apply to the security group | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| security_group_id | ID of the security group |
| security_group_name | Name of the security group |
| security_group_arn | ARN of the security group |
| vpc_id | VPC ID of the security group |

## Common Port Numbers

- SSH: 22
- HTTP: 80
- HTTPS: 443
- MySQL: 3306
- PostgreSQL: 5432
- Redis: 6379
- MongoDB: 27017
- RDP: 3389
