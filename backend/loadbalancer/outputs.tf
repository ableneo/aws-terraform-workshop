output "loadbalancer_arn" {
  value = aws_lb.app_loadbalancer.arn
}
output "loadbalancer_url" {
  value = aws_lb.app_loadbalancer.dns_name
}
output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnets" {
  value = [aws_subnet.az1.id, aws_subnet.az2.id]
}
output "security_group_id" {
  value = aws_security_group.allow_all.id
}
