resource "aws_iam_policy_attachment" "list_bookings_iam_policy_attachment" {
    name = "${var.environment}-list-bookings-iam-policy-attachment"
    roles = ["${aws_iam_role.list_bookings_iam_role.name}"]
    policy_arn = "${aws_iam_policy.list_bookings_iam_policy.arn}"
}