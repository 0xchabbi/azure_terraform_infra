# Create the Linux App Service Plan
resource "azurerm_service_plan" "appserviceplan" {
  name                = "webapp-asp-chabbi"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_application_insights" "webapp" {
  name                       = "webapp"
  resource_group_name        = azurerm_resource_group.rg1.name
  location                   = azurerm_resource_group.rg1.location
  workspace_id               = azurerm_log_analytics_workspace.prod.id
  application_type           = "web"
  sampling_percentage        = 0
  internet_ingestion_enabled = false
  internet_query_enabled     = false
}


# Create the web app, pass in the App Service Plan ID
resource "azurerm_linux_web_app" "webapp" {
  name                = "webapp-chabbi"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  service_plan_id     = azurerm_service_plan.appserviceplan.id
  https_only          = true
  site_config { #that solves the error statuscode=0
    minimum_tls_version    = "1.2"
    always_on              = false
    vnet_route_all_enabled = true
    #health_check_path = "/healhz"

    application_stack {
      docker_image     = "docker.io/bitnami/nginx"
      docker_image_tag = "latest"
    }
  }
  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY"             = azurerm_application_insights.webapp.instrumentation_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING"      = azurerm_application_insights.webapp.connection_string
    "ApplicationInsightsAgent_EXTENSION_VERSION" = "~3"
    WEBSITES_PORT                                = "8080"
  }
}

resource "azurerm_monitor_diagnostic_setting" "web-prod" {
  name                           = "web"
  target_resource_id             = azurerm_linux_web_app.webapp.id
  log_analytics_workspace_id     = azurerm_log_analytics_workspace.prod.id
  log_analytics_destination_type = "AzureDiagnostics"

  enabled_log {
    category       = "AppServiceAntivirusScanAuditLogs"
    category_group = "allLogs"

    retention_policy {
      enabled = true
      days    = 365
    }
  }

  enabled_log {
    category = "AppServiceAppLogs"

    retention_policy {
      enabled = true
      days    = 365
    }
  }

  enabled_log {
    category = "AppServiceAuditLogs"

    retention_policy {
      enabled = true
      days    = 365
    }
  }

  enabled_log {
    category = "AppServiceConsoleLogs"

    retention_policy {
      enabled = true
      days    = 365
    }
  }

  enabled_log {
    category = "AppServiceFileAuditLogs"

    retention_policy {
      enabled = true
      days    = 365
    }
  }

  enabled_log {
    category = "AppServiceHTTPLogs"

    retention_policy {
      enabled = true
      days    = 365
    }
  }

  enabled_log {
    category = "AppServicePlatformLogs"

    retention_policy {
      enabled = true
      days    = 365
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = true
      days    = 365
    }
  }
}
