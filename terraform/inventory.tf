resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/templates/inventory.tpl", {
    web_ip          = aws_instance.web_server.public_ip
    db_ip           = aws_instance.db_server.private_ip
    aws_region      = var.aws_region
    cognito_pool_id = aws_cognito_user_pool.main.id
    cognito_client_id = aws_cognito_user_pool_client.client.id
    db_secret_arn   = aws_secretsmanager_secret.db_credentials.arn
  })
  filename = "../ansible/inventory/production/hosts.ini"
}
