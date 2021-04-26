
# Creating VNet
resource "azurerm_virtual_network" "vnet-main" {
  name                = "vnet-${var.location}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-main.name
  address_space       = [var.vnet_cidr]
}

# Creating Subnets
resource "azurerm_subnet" "bastion-subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.rg-main.name
  virtual_network_name = azurerm_virtual_network.vnet-main.name
  address_prefixes     = [var.bastion_subnet_cidr]
}

resource "azurerm_subnet" "tier1-subnet" {
  name                 = "tier1-subnet"
  resource_group_name  = azurerm_resource_group.rg-main.name
  virtual_network_name = azurerm_virtual_network.vnet-main.name
  address_prefixes     = [var.tier1_subnet_cidr]
}

# Creating NSGs
resource "azurerm_network_security_group" "tier1-nsg" {
  name                = "tier1-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-main.name
}

resource "azurerm_subnet_network_security_group_association" "asso-tier1-nsg" {
  subnet_id                 = azurerm_subnet.tier1-subnet.id
  network_security_group_id = azurerm_network_security_group.tier1-nsg.id
}

