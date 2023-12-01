resource "aws_sqs_queue" "email_queue" {
    name = "${var.environment}-email-queue"
    delay_seconds = 0
    max_message_size = 262144
    message_retention_seconds = 345600
    receive_wait_time_seconds = 0
    redrive_policy = <<EOF
{
    "deadLetterTargetArn": "${aws_sqs_queue.email_queue_dlq.arn}",
    "maxReceiveCount": 3
}
    EOF
    policy = templatefile("${path.module}/templates/sqs-sns-policy.tpl", {
        source = "arn:aws:sqs:${var.region}:${var.account_id}:${var.environment}-email-queue",
        source_arn = "${aws_sns_topic.notifications.arn}"
    })
}


resource "aws_ssm_parameter" "email_sqs" {
    name = "${var.environment}-email-sqs"
    type = "String"
    value = "${aws_sqs_queue.email_queue.arn}"
}

resource "aws_sqs_queue" "email_queue_dlq" {
    name = "${var.environment}-email-queue-dlq"
    delay_seconds = 0
    max_message_size = 262144
    message_retention_seconds = 345600
    receive_wait_time_seconds = 0  
}