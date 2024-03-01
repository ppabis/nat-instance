NAT Instance
============
Running on Amazon Linux 2023.

Everything else in this repository besides the `NAT` directory should be
ignored and is described in this post:

https://pabis.eu/blog/2024-03-01-NAT-Instance-Update-Amazon-Linux-2023-CodeBuild-Terratest.html

Import the module like this:

```terraform
module "nat" {
  source          = "git::github.com/ppabis/nat-instance.git//NAT?ref=v2.0.4"
  vpc             = var.vpc_id
  public_subnet   = var.public_subnet
  private_subnet  = [var.private_subnet_a, var.private_subnet_b, var.private_subnet_c]
  route_tables    = [var.private_route_table_abc]
  elastic_ip      = true
  additional_cidr = [var.extra_cidr]
  additional_sg   = [var.extra_security_group]
}
```

Parameters
----------
- `vpc` (string, required) - VPC ID
- `name_tag` (string) - How to tag all resources created by this module. Default is `NAT-Instance`.
- `public_subnet` (string, required) - Public subnet ID to place the instance in
- `private_subnet` (list, required) - List of private subnet IDs to route traffic through the NAT instance
- `route_tables` (list, required) - List of route table IDs associated with the above private subnets
- `elastic_ip` (bool) - Whether to associate an Elastic IP with the NAT instance. You can rely on AWS
    assigned IP but then no public IP will be associated if you ever stop the instance. Default is `false`.
- `security_group` (string) (Optional) - Security group ID to use for the NAT instance. Otherwise a new one will be created.
- `additional_cidr` (list) (Optional) - List of CIDR blocks to allow traffic from. Ignored if `security_group` is set.
- `additional_sg` (list) (Optional) - List of security group IDs to allow traffic from. Ignored if `security_group` is set.
- `create_ssm_role` (bool) (Optional) - Use it only for debugging. Whether to create an IAM role for SSM access. Default is `false`.
- `iam_profile` (string) (Optional) - IAM instance profile name to use. Alternative to `create_ssm_role`. If not SSM, you probably
    don't need this.

Outputs
-------
- `public-nat-ip` - Public IP of the NAT instance
- `security_group_id` - Security group ID of the NAT instance. If you provided `security_group` parameter, this will be the same ID.
    Otherwise attach this security group to your instances that need to access the internet if you didn't add them with
    `additional_cidr` or `additional_sg`.
