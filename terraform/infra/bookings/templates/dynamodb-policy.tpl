{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "${action}"
            ],
            "Resource": "${resource}"    
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
        %{ if sns_topic != "" }
        ,
        {
            "Effect": "Allow",
            "Action": [
                "sns:Publish"
            ],
            "Resource": "${sns_topic}"
        } 
        %{ endif }
    ]
}
