#cloud-config
package_update: true
package_upgrade: true
packages:
  - nginx
  - git

runcmd:
  # Clone the GitHub repository to /var/www/html
  - rm -rf /var/www/html/*
  - git clone https://github.com/PrzemyslawSwierzewski/Tarot-strona.git /var/www/html/

  # Set permissions
  - chown -R www-data:www-data /var/www/html

  # Start and enable nginx
  - systemctl enable nginx
  - systemctl restart nginx
