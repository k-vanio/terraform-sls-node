resource "aws_dynamodb_table" "bookings" {
    name = "${var.environment}-bookings"
    billing_mode = "PROVISIONED"
    hash_key = "id"
    attribute {
        name = "id"
        type = "S"
    }
    read_capacity = "${var.read_capacity}"
    write_capacity = "${var.write_capacity}"
    stream_enabled = true
    stream_view_type = "NEW_IMAGE"
}

resource "aws_ssm_parameter" "dynamodb_bookings_table" {
    type = "String"
    name = "${var.environment}-dynamodb-bookings-table"
    value = "${aws_dynamodb_table.bookings.name}"
}

resource "aws_ssm_parameter" "dynamodb_bookings_stream" {
    type = "String"
    name = "${var.environment}-dynamodb-bookings-stream"
    value = "${aws_dynamodb_table.bookings.stream_arn}"  
}