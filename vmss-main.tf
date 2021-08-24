
data "template_file" "script-simple-iis" {
  template = file("simple-iis.ps1")
}

resource "azurerm_windows_virtual_machine_scale_set" "vmss-tier1" {
  name                = "vmss-tier1"
  location            = azurerm_resource_group.rg-main.location
  resource_group_name = azurerm_resource_group.rg-main.name

  sku        = var.win_compute_size
  instances  = 2

  computer_name_prefix  = var.vmss-tier1-prefix
  admin_username        = var.win_admin_name
  admin_password        = var.win_admin_pass

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = var.win_sku
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "${var.vmss-tier1-prefix}-nic"
    primary = true

    ip_configuration {
      name      = "${var.vmss-tier1-prefix}-pvt"
      primary   = true
      subnet_id = azurerm_subnet.tier1-subnet.id
    }
  }

  extension {
    name                       = "CustomScript"
    publisher                  = "Microsoft.Compute"
    type                       = "CustomScriptExtension"
    type_handler_version       = "1.10"
    auto_upgrade_minor_version = true
    settings = jsonencode({ "commandToExecute" = "powershell -command \"[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String('${base64encode(data.template_file.script-simple-iis.rendered)}')) | Out-File -filepath simple-iis.ps1\" && powershell -ExecutionPolicy Unrestricted -File simple-iis.ps1" })
  }

   encryption_at_host_enabled = true
}