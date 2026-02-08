resource "aws_apigatewayv2_api" "apig" {
  name          = "${var.name}-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_vpc_link" "this" {
  name        = "${var.name}-vpc-link"
  subnet_ids  = var.private_subnet_ids
  security_group_ids = [aws_security_group.alb_sg.id]
}

resource "aws_apigatewayv2_integration" "alb_integration" {
  api_id             = aws_apigatewayv2_api.apig.id
  integration_type   = "HTTP_PROXY"
  integration_uri    = aws_lb.internal.dns_name
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.apig.id
  payload_format_version = "1.0"
}

resource "aws_apigatewayv2_route" "default" {
  api_id    = aws_apigatewayv2_api.apig.id
  route_key = "ANY /{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.alb_integration.id}"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.apig.id
  name        = "$default"
  auto_deploy = true
}
