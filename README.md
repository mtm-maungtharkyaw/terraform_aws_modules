# Terraform Modules

Reusable Terraform modules for AWS infrastructure.

## Available Modules

### IAM Role (`iam/role`)

Complete IAM role module with support for trust policies, managed policies, inline policies, and session configuration.

**Usage:**
```hcl
module "ec2_role" {
  source = "./modules/iam/role"

  name                = "ec2-app-role"
  trusted_entity_type = "Service"
  trusted_identifiers = ["ec2.amazonaws.com"]
  policy_arns         = ["arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"]
}
```

See [iam/role/README.md](./iam/role/README.md) for full documentation.
