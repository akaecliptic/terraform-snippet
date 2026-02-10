// docker containers to deploy
resource "aws_ecr_repository" "repositories" {
  for_each             = var.repository_names
  name                 = each.key
  image_tag_mutability = "MUTABLE"
}

// any secrets need for application to run
resource "aws_secretsmanager_secret" "secrets" {
  for_each = var.secret_names
  name     = each.key
}
