output "role_arn" {
  value = aws_iam_role.sudharshan_role.arn
}

output "role_name" {
  value = aws_iam_role.sudharshan_role.name
}

output "policy_arn" {
  value = aws_iam_policy.sudharshan_policy.arn
}

output "policy_name" {
  value = aws_iam_policy.sudharshan_policy.name
}

output "bucket_name" {
  value = aws_s3_bucket.sudharshanshady_bucket.id
}


