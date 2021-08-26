resource "aws_iam_role" "media_convert_role" {
  name = "media_convert_role"

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : "sts:AssumeRole",
          "Principal" : {
            "Service" : "mediaconvert.amazonaws.com"
          },
          "Effect" : "Allow",
          "Sid" : ""
        }
      ]
  })
  inline_policy {
    name = "media_convert_inline_policy"
    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "",
          "Effect" : "Allow",
          "Action" : [
            "s3:List*",
            "s3:Get*",
            "s3:Create*",
            "s3:Put*"

          ],
          "Resource" : "*"
        },
        {
          "Sid" : "",
          "Effect" : "Allow",
          "Action" : [
            "execute-api:Invoke",
            "execute-api:ManageConnections",
          ],
          "Resource" : "arn:aws:execute-api:*:*:*"
        }
      ]

    })
  }
  tags = {
    Name      = "media_convert_role"
    ManagedBy = "terraform"
  }
}


resource "aws_ssm_parameter" "media_convert_role" {
  name        = "media_convert_role"
  description = "media_convert_role "
  type        = "String"
  value       = aws_iam_role.media_convert_role.arn
}
