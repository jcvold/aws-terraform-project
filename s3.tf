# S3 bucket
resource "aws_s3_bucket" "nginx_bucket" {
  bucket = "nginxbucketjcv123"
}

# IAM roles & policies
data "aws_iam_policy_document" "nginx_s3_policy" {
  statement {
    actions   = ["s3:PutObject"]
    resources = [aws_s3_bucket.nginx_bucket.arn]
  }
}

resource "aws_iam_role" "ecs_task_role" {
  name = "ecs_task-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "nginx_s3_policy" {
  name        = "s3-policy"
  description = "S3 access policy"
  policy      = data.aws_iam_policy_document.nginx_s3_policy.json
}

resource "aws_iam_policy_attachment" "nginx_s3_policy_attachment" {
  name       = "s3-policy-attachment"
  policy_arn = aws_iam_policy.nginx_s3_policy.arn
  roles      = [aws_iam_role.ecs_task_role.name]
}
