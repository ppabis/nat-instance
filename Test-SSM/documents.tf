resource "aws_ssm_document" "test-curl" {
  name            = "TestInternetConnectivity"
  document_type   = "Command"
  document_format = "YAML"
  content         = file("${path.module}/test-curl.yaml")
}
