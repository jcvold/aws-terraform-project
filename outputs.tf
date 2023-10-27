output "alb_url" {
  value = "http://${aws_alb.nginx_alb.dns_name}"
}
