# IAM Role Module

Complete IAM role module supporting all AWS Console role dashboard features.

## Features

- ✅ **Trust Policy**: Support for Service, AWS Account, and Federated identities
- ✅ **Managed Policies**: Attach AWS managed or customer managed policies
- ✅ **Inline Policies**: Create inline policies directly on the role
- ✅ **Session Duration**: Configure max session duration
- ✅ **Tags**: Apply tags to the role
- ✅ **Description**: Add role description

## Usage Examples

### 1. EC2 Instance Role
```hcl
module "ec2_role" {
  source = "./modules/iam/role"

  name                  = "ec2-web-server-role"
  description           = "Role for EC2 web server instances"
  trusted_entity_type   = "Service"
  trusted_identifiers   = ["ec2.amazonaws.com"]
  policy_arns           = [
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  ]
  tags = {
    Environment = "production"
    Application = "web-server"
  }
}
```

### 2. Lambda Execution Role
```hcl
module "lambda_role" {
  source = "./modules/iam/role"

  name                  = "lambda-execution-role"
  trusted_entity_type   = "Service"
  trusted_identifiers   = ["lambda.amazonaws.com"]
  policy_arns           = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  ]
  max_session_duration  = 3600
}
```

### 3. Cross-Account Role
```hcl
module "cross_account_role" {
  source = "./modules/iam/role"

  name                  = "cross-account-access"
  description           = "Allow access from another AWS account"
  trusted_entity_type   = "AWS"
  trusted_identifiers   = ["arn:aws:iam::123456789012:root"]
  policy_arns           = [
    "arn:aws:iam::aws:policy/ReadOnlyAccess"
  ]
}
```

### 4. Role with Inline Policy
```hcl
module "custom_role" {
  source = "./modules/iam/role"

  name                  = "custom-application-role"
  trusted_entity_type   = "Service"
  trusted_identifiers   = ["ec2.amazonaws.com"]
  
  inline_policies = {
    s3_access = jsonencode({
      Version = "2012-10-17"
      Statement = [{
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = "arn:aws:s3:::my-bucket/*"
      }]
    })
  }
}
```

### 5. ECS Task Role
```hcl
module "ecs_task_role" {
  source = "./modules/iam/role"

  name                  = "ecs-task-role"
  trusted_entity_type   = "Service"
  trusted_identifiers   = ["ecs-tasks.amazonaws.com"]
  policy_arns           = [
    "arn:aws:iam::aws:policy/AmazonDynamoDBReadOnlyAccess"
  ]
  max_session_duration  = 7200
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| name | Name of the IAM role | string | - | yes |
| description | Description of the role | string | "" | no |
| trusted_entity_type | Service, AWS, or Federated | string | "Service" | no |
| trusted_identifiers | List of trusted entities | list(string) | - | yes |
| policy_arns | Managed policy ARNs to attach | list(string) | [] | no |
| inline_policies | Map of inline policies | map(string) | {} | no |
| max_session_duration | Max session duration (3600-43200) | number | 3600 | no |
| tags | Tags for the role | map(string) | {} | no |

## Outputs

| Name | Description |
|------|-------------|
| role_arn | ARN of the role |
| role_name | Name of the role |
| role_id | ID of the role |
| role_unique_id | Unique ID of the role |

## Trusted Entity Types

- **Service**: `ec2.amazonaws.com`, `lambda.amazonaws.com`, `ecs-tasks.amazonaws.com`, etc.
- **AWS**: `arn:aws:iam::ACCOUNT_ID:root`, `arn:aws:iam::ACCOUNT_ID:user/username`
- **Federated**: `arn:aws:iam::ACCOUNT_ID:oidc-provider/...`, `arn:aws:iam::ACCOUNT_ID:saml-provider/...`
