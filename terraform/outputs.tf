output "web_server_public_ip" {
  value = aws_instance.web_server.public_ip
}

output "db_server_private_ip" {
  value = aws_instance.db_server.private_ip
}

output "cognito_pool_id" {
  value = aws_cognito_user_pool.main.id
}

output "cognito_client_id" {
  value = aws_cognito_user_pool_client.client.id
}

output "db_secret_arn" {
  value = aws_secretsmanager_secret.db_credentials.arn
}
