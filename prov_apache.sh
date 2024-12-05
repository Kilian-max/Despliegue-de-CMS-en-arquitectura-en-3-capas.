# Instalar Apache y otras dependencias necesarias
apt-get update && apt-get upgrade -y
apt-get install apache2 nfs-common -y
apt-get install php libapache2-mod-php php-mysql php-xml php-mbstring php-curl php-zip php-gd -y

# Montar el directorio compartido desde el servidor NFS
mkdir -p /var/www/html2
echo "192.168.57.13:/var/nfs/wordpress /var/www/html2 nfs defaults 0 0" >> /etc/fstab
mount -a

# Configurar Apache para servir el contenido
cat <<EOL > /etc/apache2/sites-available/000-default.conf
<VirtualHost *:80>
  DocumentRoot /var/www/html2
  <Directory /var/www/html2>
      Options Indexes FollowSymLinks
      AllowOverride All
      Require all granted
  </Directory>

  ErrorLog \${APACHE_LOG_DIR}/error.log
  CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOL

# Habilitar módulos de Apache y reiniciar el servicio
a2enmod rewrite
systemctl restart apache2