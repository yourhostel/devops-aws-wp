# modules/iam/outputs.tf

# Доступ до ReadOnly користувача
output "readonly_user_credentials" {
  description = "Access keys for the ReadOnly IAM user"
  value = {
    access_key_id     = aws_iam_access_key.readonly_user_key.id
    secret_access_key = aws_iam_access_key.readonly_user_key.secret
  }
  sensitive = true
}

# Доступ до WordPress admin користувача
output "wordpress_admin_credentials" {
  description = "Access keys for the WordPress admin IAM user"
  value = {
    access_key_id     = aws_iam_access_key.wordpress_admin_key.id
    secret_access_key = aws_iam_access_key.wordpress_admin_key.secret
  }
  sensitive = true
}
