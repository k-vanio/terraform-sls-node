resource "aws_sns_topic_subscription" "email_subscriptions" {
    topic_arn = "${aws_sns_topic.notifications.arn}"
    protocol = "sqs"
    endpoint = "${aws_sqs_queue.email_queue.arn}"
}

resource "aws_sns_topic_subscription" "sms_subscriptions" {
    topic_arn = "${aws_sns_topic.notifications.arn}"
    protocol = "sqs"
    endpoint = "${aws_sqs_queue.sms_queue.arn}"
}