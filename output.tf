output "ec2_a" {
  value = aws_instance.ec2_a.public_ip
}

output "ec2_b" {
  value = aws_instance.ec2_b.public_ip
}

output "VPC_A_ID" {
    value = aws_vpc.vpc-test.id
}

output "VPC_B_ID" {
    value = aws_vpc.vpc-prod.id
}
