resource "aws_ecr_repository" "api_repo" {
  name = "api_repo"

  tags = merge(local.default_tags,
    {
      Name      = "ECR Repo"
    }
  )
}

resource "aws_ecr_lifecycle_policy" "api_repo_policy" {
  repository = aws_ecr_repository.api_repo.name

  policy = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Keep image deployed with tag latest",
      "selection": {
        "tagStatus": "tagged",
        "tagPrefixList": ["latest"],
        "countType": "imageCountMoreThan",
        "countNumber": 1
      },
      "action": {
        "type": "expire"
      }
    },
    {
      "rulePriority": 2,
      "description": "Keep last 2 any images",
      "selection": {
        "tagStatus": "any",
        "countType": "imageCountMoreThan",
        "countNumber": 2
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF
}
