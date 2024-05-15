#Giving full permissions since I could not run it without localstack token, to test the required permissions,
resource "aws_iam_role" "lambda_role" {
  name = "AdminRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "*"
        }
        Sid = "admin"
      },
    ]
  })
}

resource "aws_iam_policy_attachment" "admin_attach" {
  name       = "AdminPolicyAttachment"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess" # This is the ARN for the AdministratorAccess policy
}

resource "aws_lambda_function" "first_lambda" {
  function_name = "firstLambdaFunction"
  package_type  = "Image"
  image_uri     = "jonathanpick/first-lambda:v1"
  role          = aws_iam_role.lambda_role.arn
}

resource "aws_lambda_function" "second_lambda" {
  function_name = "secondLambdaFunction"
  package_type  = "Image"
  image_uri     = "jonathanpick/second-lambda:v1"
  role          = aws_iam_role.lambda_role.arn
}
