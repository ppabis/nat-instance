resource "aws_codestarconnections_connection" "GitHub" {
  provider_type = "GitHub"
  name          = "GitHubConnection-ppabis"
  tags          = { Name = "GitHubConnection-ppabis" }
}
