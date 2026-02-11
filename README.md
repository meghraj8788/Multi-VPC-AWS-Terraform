Designed and Provisioned Multi-VPC Architecture on AWS Using Terraform


created two separate VPCs using Terraform. Each VPC has one public subnet and one private subnet. We attached an Internet Gateway for public access and configured route tables properly. Then we launched EC2 instances in both VPCs and controlled access using security groups. Everything was created using Terraform (Infrastructure as Code) instead of manual setup.



Final Architecture
VPC-A (10.0.0.0/16)
 ├── Public Subnet (10.0.1.0/24)
 ├── Private Subnet (10.0.2.0/24)
 └── EC2 (in public subnet)

VPC-B (10.1.0.0/16)
 ├── Public Subnet (10.1.1.0/24)
 ├── Private Subnet (10.1.2.0/24)
 └── EC2 (in public subnet)
 
