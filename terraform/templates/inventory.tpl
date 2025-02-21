[web]
web_server ansible_host=${web_ip} ansible_user=ubuntu

[web:vars]
cognito_pool_id=${cognito_pool_id}
cognito_client_id=${cognito_client_id}
db_secret_arn=${db_secret_arn}
db_private_ip = ${db_ip}
aws_region = ${aws_region}
[db]
db_server ansible_host=${db_ip} ansible_user=ubuntu

[db:vars]
ansible_ssh_common_args='-o ProxyCommand="ssh -W %h:%p -q ubuntu@${web_ip}"'
db_secret_arn=${db_secret_arn}
db_private_ip = ${db_ip}
aws_region = ${aws_region}
