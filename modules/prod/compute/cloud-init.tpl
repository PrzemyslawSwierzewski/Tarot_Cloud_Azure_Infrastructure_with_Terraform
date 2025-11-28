#cloud-config
package_update: true
package_upgrade: true
packages:
  - nginx
  - azure-cli
  - git

runcmd:
  # Log in with the managed identity
  - az login --identity

  # The Key Vault name is passed in as a variable from Terraform.
  - export POSTGRES_PASSWORD=$(az keyvault secret show --name "postgres-password" --vault-name "${key_vault_name}" --query "value" -o tsv)

  # Clone the GitHub repository to /var/www/html
  - rm -rf /var/www/html/*
  - git clone https://github.com/PrzemyslawSwierzewski/Tarot-strona.git /var/www/html/


  # - echo "DB_PASSWORD=$POSTGRES_PASSWORD" > /var/www/html/.env

  # Set permissions
  - chown -R www-data:www-data /var/www/html

  # Start and enable nginx
  - systemctl enable nginx
  - systemctl restart nginx
