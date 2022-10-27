resource "aws_codestarconnections_connection" "e2msolutions-github" {
  name          = "e2msolutions-github-connection"
  provider_type = "GitHub"
}