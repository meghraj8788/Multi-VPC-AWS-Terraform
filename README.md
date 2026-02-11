Designed and Provisioned Multi-VPC Architecture on AWS Using Terraform

Final Architecture
VPC-A (10.0.0.0/16)
 ├── Public Subnet (10.0.1.0/24)
 ├── Private Subnet (10.0.2.0/24)
 └── EC2 (in public subnet)

VPC-B (10.1.0.0/16)
 ├── Public Subnet (10.1.1.0/24)
 ├── Private Subnet (10.1.2.0/24)
 └── EC2 (in public subnet)
 
