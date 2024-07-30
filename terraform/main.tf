#imported resource
resource "azurerm_virtual_network" "NE-Dev-Network" {
  name                = "NE-Dev-vNet-01"
  location            = "northeurope"
  resource_group_name = "NE-Dev-Network"
  address_space       = ["192.168.0.0/16"]
  tags = {
    created-by      = "aalhazmi"
    requested-by    = "salajlan"
    created-email   = "aalhazmi@ncai2.onmicrosoft.com"
    team            = "DevOps"
    created-at      = "2024-07-29"
    requested-email = "salajlan@nic.gov.sa"
  }
}

#imported resource
resource "azurerm_subnet" "aks-dev-subnet" {
  name                 = "aks-dev-subnet"
  resource_group_name  = "NE-Dev-Network"
  address_prefixes     = ["192.168.100.0/24"]
  virtual_network_name = azurerm_virtual_network.NE-Dev-Network.name
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
    subnet_id                     = azurerm_subnet.aks-dev-subnet.id
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

resource "azurerm_network_security_group" "tf-sg" {
  name                = "aalhazmi-sg"
  location            = azurerm_resource_group.tf-rg.location
  resource_group_name = azurerm_resource_group.tf-rg.name
  security_rule {
    name                       = "vm-sg"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "22"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  tags = {
    created-by      = "aalhazmi"
    requested-by    = "salajlan"
    created-email   = "aalhazmi@ncai2.onmicrosoft.com"
    team            = "DevOps"
    created-at      = "2024-07-29"
    requested-email = "salajlan@nic.gov.sa"
  }
}

resource "azurerm_network_interface_security_group_association" "tf-sga" {
  network_interface_id      = azurerm_network_interface.tf-nic.id
  network_security_group_id = azurerm_network_security_group.tf-sg.id
}