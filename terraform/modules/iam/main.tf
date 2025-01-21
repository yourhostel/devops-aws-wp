# modules/iam/main.tf

# Створення IAM користувача з політикою ReadOnlyAccess
resource "aws_iam_user" "readonly_user" {
  name = "${var.project_name}-readonly-user"

  tags = merge(var.tags, {
    Name = "${var.project_name}-readonly-user"
  })
}

# Прикріплення політики ReadOnlyAccess до користувача
resource "aws_iam_user_policy_attachment" "readonly_access" {
  user       = aws_iam_user.readonly_user.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

# Створення IAM користувача для WordPress admin
resource "aws_iam_user" "wordpress_admin" {
  name = "${var.project_name}-wordpress-admin"

  tags = merge(var.tags, {
    Name = "${var.project_name}-wordpress-admin"
  })
}

# Створення кастомної політики для WordPress admin
resource "aws_iam_user_policy" "wordpress_policy" {
  name   = "${var.project_name}-wordpress-policy"
  user   = aws_iam_user.wordpress_admin.name
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "rds:DescribeDBInstances",
          "elasticache:DescribeCacheClusters",
          "elasticache:DescribeReplicationGroups"
        ],
        Resource = "*"
      }
    ]
  })
}

# Створення ключів доступу для користувачів
resource "aws_iam_access_key" "readonly_user_key" {
  user = aws_iam_user.readonly_user.name
}

resource "aws_iam_access_key" "wordpress_admin_key" {
  user = aws_iam_user.wordpress_admin.name
}

