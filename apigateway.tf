resource "azurerm_application_gateway" "network" {
  name                = "myAppGateway-chabbi"
  resource_group_name = azurerm_resource_group.rg1.name
  location            = azurerm_resource_group.rg1.location


  sku { #check which requirement you need to scale your sku
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 1 #change capacity because of low requirement
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = azurerm_subnet.frontend.id
  }

  frontend_port {
    name = var.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = var.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.pip1.id
  }

  backend_address_pool {
    name = var.backend_address_pool_name
    fqdns = [
      "webapp-chabbi.azurewebsites.net",
    ]
  }

  ## format through shift+crtl+p format document 
  backend_http_settings {
    name                                = var.http_setting_name
    cookie_based_affinity               = "Disabled"
    affinity_cookie_name                = "ApplicationGatewayAffinity"
    port                                = 443
    protocol                            = "Https"
    request_timeout                     = 60
    host_name                           = "webapp-chabbi.azurewebsites.net"
    pick_host_name_from_backend_address = false
    probe_name                          = "myhealth"
  }

  probe {
    host     = "webapp-chabbi.azurewebsites.net"
    interval = 10
    #minimum_servers       = 0
    name = "myhealth"
    path = "/"
    #pick_host_name_from_backend_http_settings = false
    #port                  = 0
    protocol            = "Https"
    timeout             = 30
    unhealthy_threshold = 3

    match {
      status_code = [
        "200-399",
      ]
    }
  }

  http_listener {
    name                           = var.listener_name
    frontend_ip_configuration_name = var.frontend_ip_configuration_name
    frontend_port_name             = var.frontend_port_name
    protocol                       = "Http"
    host_names                     = ["webapp-chabbi.azurewebsites.net"]
  }


  request_routing_rule {
    name                       = "webapprouting" #var.request_routing_rule_name
    rule_type                  = "PathBasedRouting"
    http_listener_name         = var.listener_name
    backend_address_pool_name  = var.backend_address_pool_name
    backend_http_settings_name = var.http_setting_name
    priority                   = 10
    url_path_map_name          = "webapprouting"
  }
  url_path_map {
    default_backend_address_pool_name  = "myBackendPool"
    default_backend_http_settings_name = "myHTTPsetting"
    name                               = "webapprouting"
    path_rule {
      backend_address_pool_name  = var.backend_address_pool_name
      backend_http_settings_name = "myHTTPsetting"
      name                       = "webapp1"
      paths = [
        "/*",
      ]
    }
  }
}
