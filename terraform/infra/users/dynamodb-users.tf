resource "aws_dynamodb_table" "users" {
    name = "${var.environment}-users"
    billing_mode = "PROVISIONED"
    hash_key = "id"
    attribute {
        name = "id"
        type = "S"
    }
    read_capacity = "${var.read_capacity}"
    write_capacity = "${var.write_capacity}"

    attribute {
        name = "email"
        type = "S"    
    }

    global_secondary_index {
        name = "${var.environment}-email-gsi"
        hash_key = "email"
        projection_type = "ALL"
        write_capacity = "${var.write_capacity}"
        read_capacity = "${var.read_capacity}"    
    }
}

resource "aws_dynamodb_table_item" "admin" {
    table_name = "${aws_dynamodb_table.users.name}"
    hash_key = "${aws_dynamodb_table.users.hash_key}"
    item = <<ITEM
{
    "id": {"S": "${var.admin_id}"},
    "name": {"S": "${var.admin_name}"},
    "email": {"S": "${var.admin_email}"},
    "password": {"S": "${var.admin_password}"},
    "role": {"S": "admin"}
}
    ITEM
}

resource "aws_ssm_parameter" "dynamodb_users_table" {
    type = "String"
    name = "${var.environment}-dynamodb-users-table"
    value = "${aws_dynamodb_table.users.name}"
}

resource "aws_ssm_parameter" "email-gsi" {
    type = "String"
    name = "${var.environment}-email-gsi"
    value = "${var.environment}-email-gsi"  
}