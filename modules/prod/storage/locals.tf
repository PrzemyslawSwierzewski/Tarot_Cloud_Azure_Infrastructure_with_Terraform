locals {
    environment                               = "prod"
    SA_account_tier                           = "Standard"
    storage_account_name                      = "storageaccountforprodmon"
    SA_account_replication_type               = "LRS"
    container_name                            = "monitoringcontainer"
    container_access_type = "private"
    min_tls_version = "TLS1_2"
}