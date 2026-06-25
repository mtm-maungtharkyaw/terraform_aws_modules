data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = var.trusted_entity_type
      identifiers = var.trusted_identifiers
    }
  }
}

resource "aws_iam_role" "role" {
  name                 = var.name
  description          = var.description
  assume_role_policy   = data.aws_iam_policy_document.assume_role.json
  max_session_duration = var.max_session_duration
  tags                 = var.tags
}

resource "aws_iam_role_policy_attachment" "managed_policies" {
  for_each   = toset(var.policy_arns)
  role       = aws_iam_role.role.name
  policy_arn = each.value
}

resource "aws_iam_role_policy" "inline_policies" {
  for_each = var.inline_policies
  name     = each.key
  role     = aws_iam_role.role.id
  policy   = each.value
}
