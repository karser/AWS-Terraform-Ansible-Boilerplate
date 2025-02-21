resource "aws_iam_role" "web_instance_role" {
  name = "web_instance_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy" "web_secrets" {
  name = "WebSecretsManagerAccess"
  role = aws_iam_role.web_instance_role.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow",
      Action   = "secretsmanager:GetSecretValue",
      Resource = aws_secretsmanager_secret.db_credentials.arn
    }]
  })
}

resource "aws_iam_role_policy_attachment" "web_ssm" {
  role       = aws_iam_role.web_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "web" {
  name = "web_instance_profile"
  role = aws_iam_role.web_instance_role.name
}




resource "aws_iam_role" "db_instance_role" {
  name = "db_instance_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy" "db_secrets" {
  name = "SecretsManagerAccess"
  role = aws_iam_role.db_instance_role.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "secretsmanager:GetSecretValue"
      Resource = aws_secretsmanager_secret.db_credentials.arn
    }]
  })
}

resource "aws_iam_instance_profile" "db" {
  name = "db_instance_profile"
  role = aws_iam_role.db_instance_role.name
}
