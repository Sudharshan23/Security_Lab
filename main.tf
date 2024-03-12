# Define IAM Role
resource "aws_iam_role" "sudharshan_role" {
  name = "sudharshan-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [{
      "Effect" : "Allow",
      "Principal" : {
        "Service" : "ec2.amazonaws.com"
      },
      "Action" : "sts:AssumeRole"
    }]
  })
}

# Create inline policy allowing S3 bucket creation
resource "aws_iam_policy" "sudharshan_policy" {
  name        = "sudharshan-policy"
  description = "Inline policy for the IAM role"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [{
      "Effect" : "Allow",
      "Action" : "s3:CreateBucket",
      "Resource" : "arn:aws:s3:::sudharshannew-bucket"
    },
    {
      "Effect" : "Allow",
      "Action" : [
        "s3:GetBucketLocation",
        "s3:ListAllMyBuckets"
      ],
      "Resource" : "*"
    }]
  })
}

# Attach the policy to the IAM role
resource "aws_iam_role_policy_attachment" "policy-role_attachment" {
  role       = aws_iam_role.sudharshan_role.name
  policy_arn = aws_iam_policy.sudharshan_policy.arn
}

# Use the IAM role to create an S3 bucket
resource "aws_s3_bucket" "sudharshanshady_bucket" {
  bucket = "sudharshannew-bucket"

  tags = {
    Name = "Cloud security test Bucket"
  }
}

# Disassociate the policy from the role
resource "aws_iam_role_policy_attachment" "remove_policy-role_attachment" {
  role       = aws_iam_role.sudharshan_role.name
  policy_arn = aws_iam_policy.sudharshan_policy.arn
  count      = 0
}

# Remove the IAM role
resource "null_resource" "detach_policies" {
  triggers = {
    role_name = aws_iam_role.sudharshan_role.name
  }

  provisioner "local-exec" {
    command     = "aws iam list-attached-role-policies --role-name ${aws_iam_role.sudharshan_role.name} --query 'AttachedPolicies[].PolicyArn' --output text | xargs -I {} aws iam detach-role-policy --role-name ${aws_iam_role.sudharshan_role.name} --policy-arn {}"
    interpreter = ["bash", "-c"]
  }
}

resource "null_resource" "remove_sudharshan_role" {
  depends_on = [null_resource.detach_policies]

  triggers = {
    role_name = aws_iam_role.sudharshan_role.name
  }

  provisioner "local-exec" {
    command     = "aws iam delete-role --role-name ${aws_iam_role.sudharshan_role.name}"
    interpreter = ["bash", "-c"]
  }
}
