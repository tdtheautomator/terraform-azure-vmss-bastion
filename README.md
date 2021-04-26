# Virtual Machine Scale Set with Bastion
This plan is used to deploy Virtual Machine Scale Set and a Bastion Host
variable vaules are managed in tfvars file.

## What Does this plan do ?
A total of 9 resources are created.

1. Creates a 1 Resource Group in westus2
2. Creates 1 Virtual Network
3. Creates 2 Subnets
   * bastion-subnet 
   * tier1-subnet
4. Creates 1 Network Security Group
5.  Creates 1 Public IPs for Bastion
6.  Creates 1 Virtual Machine Scale Set with 2 Instances
    * OS SKU : Windows Server 2019
    * Instance Size : Standard_B2s
    * Instance are enabled with custom extension to deploy IIS
     

authenticate using : 
```
az login
```

post authentication token is received :

```
terraform init
terraform plan
terraform apply
```

*connection to bastion from internet is allowed by default*
*connection from bastion to all subnets in VNet is allowed by default*
*NSGs should be appropriately configured*