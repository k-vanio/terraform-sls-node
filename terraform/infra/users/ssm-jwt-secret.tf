resource "aws_ssm_parameter" "jwt_secret" {
    type = "String"
    name = "${var.environment}-jwt-secret"
    value = "${var.jwt_secret}"
}