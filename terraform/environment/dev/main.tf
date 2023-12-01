data "aws_caller_identity" "current" {}

module "users" {
    source = "../../infra/users"
    environment = "${var.environment}"
    read_capacity = "${var.read_capacity}"
    write_capacity = "${var.write_capacity}"
    jwt_secret = "${var.jwt_secret}"
    // admin
    admin_id = "${var.admin_id}"
    admin_name = "${var.admin_name}"
    admin_email = "${var.admin_email}"
    admin_password = "${var.admin_password}"
}

module "bookings" {
    source = "../../infra/bookings"
    environment = "${var.environment}"
    read_capacity = "${var.read_capacity}"
    write_capacity = "${var.write_capacity}"
    sns_notifications_arn = "${module.notifications.notifications_topic_arn}"
}

module "notifications" {
    source = "../../infra/notifications"
    environment = "${var.environment}"
    account_id = "${data.aws_caller_identity.current.account_id}"
    region = "${var.region}"
}

module "system" {
    source = "../../infra/system"
    environment = "${var.environment}"
    email_from = "${var.email_from}"
    email_from_password = "${var.email_from_password}"
    email_to = "${var.email_to}"
    smtp_server = "${var.smtp_server}"
}