# EC2 Instance Module

Module for creating AWS EC2 instances with configurable storage, networking, and IAM settings.

## Features

- ✅ Instance configuration (AMI, type, subnet, security groups)
- ✅ IAM instance profile support
- ✅ Root volume configuration (size, type, encryption)
- ✅ Additional EBS volumes
- ✅ User data support
- ✅ Detailed CloudWatch monitoring
- ✅ Lifecycle management

## Usage

### Basic EC2 Instance
```hcl
module "web_server" {
  source = "./modules/ec2"

  name               = "web-server"
  ami_id             = "ami-0c55b159cbfafe1f0"
  instance_type      = "t3.micro"
  subnet_id          = "subnet-12345678"
  security_group_ids = ["sg-12345678"]
  key_name           = "my-key"
  
  tags = {
    Environment = "production"
  }
}
```

### EC2 with IAM Role
```hcl
module "app_server" {
  source = "./modules/ec2"

  name                 = "app-server"
  ami_id               = "ami-0c55b159cbfafe1f0"
  instance_type        = "t3.small"
  subnet_id            = "subnet-12345678"
  security_group_ids   = ["sg-12345678"]
  iam_instance_profile = module.ec2_role.role_name
  
  root_volume_size = 20
  root_volume_type = "gp3"
}
```

### EC2 with Additional EBS Volumes
```hcl
module "data_server" {
  source = "./modules/ec2"

  name               = "data-server"
  ami_id             = "ami-0c55b159cbfafe1f0"
  instance_type      = "t3.medium"
  subnet_id          = "subnet-12345678"
  security_group_ids = ["sg-12345678"]
  
  ebs_volumes = [
    {
      device_name           = "/dev/sdf"
      volume_size           = 100
      volume_type           = "gp3"
      encrypted             = true
      delete_on_termination = true
    }
  ]
}
```

### EC2 with User Data
```hcl
module "web_server" {
  source = "./modules/ec2"

  name               = "web-server"
  ami_id             = "ami-0c55b159cbfafe1f0"
  instance_type      = "t3.micro"
  subnet_id          = "subnet-12345678"
  security_group_ids = ["sg-12345678"]
  
  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
  EOF
  
  user_data_replace_on_change = true
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| name | Name tag for the instance | string | - | yes |
| ami_id | AMI ID | string | - | yes |
| instance_type | Instance type | string | "t3.micro" | no |
| subnet_id | Subnet ID | string | - | yes |
| security_group_ids | Security group IDs | list(string) | [] | no |
| iam_instance_profile | IAM instance profile name | string | null | no |
| key_name | SSH key pair name | string | null | no |
| user_data | User data script | string | null | no |
| user_data_replace_on_change | Replace instance on user data change | bool | false | no |
| enable_detailed_monitoring | Enable detailed monitoring | bool | false | no |
| root_volume_size | Root volume size (GB) | number | 8 | no |
| root_volume_type | Root volume type | string | "gp3" | no |
| root_volume_encrypted | Encrypt root volume | bool | true | no |
| root_volume_delete_on_termination | Delete root volume on termination | bool | true | no |
| ebs_volumes | Additional EBS volumes | list(object) | [] | no |
| tags | Tags for the instance | map(string) | {} | no |
| ignore_changes | Lifecycle ignore changes | list(string) | [] | no |

## Outputs

| Name | Description |
|------|-------------|
| instance_id | EC2 instance ID |
| instance_arn | EC2 instance ARN |
| public_ip | Public IP address |
| private_ip | Private IP address |
| public_dns | Public DNS name |
| private_dns | Private DNS name |
