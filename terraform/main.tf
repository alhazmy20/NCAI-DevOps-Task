#imported resource
data "azurerm_virtual_network" "NE-Dev-vNet-01" {
  name                = "NE-Dev-vNet-01"
  resource_group_name = "NE-Dev-Network"
}
 
data "azurerm_subnet" "aks-dev-subnet" {
  name                 = "aks-dev-subnet"
  virtual_network_name = "NE-Dev-vNet-01"
  resource_group_name  = "NE-Dev-Network"
}

resource "azurerm_resource_group" "tf-rg" {
  name     = "terraform-aalhazmi"
  location = "northeurope"
}

#terraform destroy --target azurerm_network_interface.tf-nic
resource "azurerm_network_interface" "tf-nic" {
  name                = "aalhazmi-nic"
  location            = azurerm_resource_group.tf-rg.location
  resource_group_name = azurerm_resource_group.tf-rg.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.aks-dev-subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "192.168.100.11"
  }
  tags = {
    created-by      = "aalhazmi"
    requested-by    = "salajlan"
    created-email   = "aalhazmi@ncai2.onmicrosoft.com"
    team            = "DevOps"
    created-at      = "2024-07-29"
    requested-email = "salajlan@nic.gov.sa"
  }
  depends_on = [
    azurerm_resource_group.tf-rg
  ]
}

resource "azurerm_linux_virtual_machine" "tf-vm" {
  name                = "aalhazmi-vm"
  resource_group_name = azurerm_resource_group.tf-rg.name
  location            = azurerm_resource_group.tf-rg.location
  size                = "Standard_D2s_v3"
  admin_username      = "adminuser"
  #admin_password                  = "Pass123456789@"
  #disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.tf-nic.id,
  ]
  admin_ssh_key {
    username   = "adminuser"
    public_key = file("C:\\Users\\aalhazmi\\.ssh\\id_rsa.pub")
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  tags = {
    created-by      = "aalhazmi"
    requested-by    = "salajlan"
    created-email   = "aalhazmi@ncai2.onmicrosoft.com"
    team            = "DevOps"
    created-at      = "2024-07-29"
    requested-email = "salajlan@nic.gov.sa"
  }
  depends_on = [
    azurerm_network_interface.tf-nic
  ]
}