# Actualizar el sistema
apt-get update && apt-get upgrade -y

# Instalar NFS y herramientas necesarias
apt-get install nfs-kernel-server wget unzip -y

# Crear el directorio compartido para WordPress
mkdir -p /var/nfs

# Descargar WordPress
wget -c https://wordpress.org/latest.zip 

# Descomprimir WordPress directamente en el directorio de destino
unzip latest.zip -d /var/nfs

# Configurar permisos
chown -R nobody:nogroup /var/nfs/wordpress
chmod -R 755 /var/nfs/wordpress

# Exportar el directorio NFS
echo "/var/nfs/wordpress 192.168.57.0/24(rw,sync,no_subtree_check)" >> /etc/exports
exportfs -ra

# Reiniciar el servicio NFS
systemctl restart nfs-kernel-server

echo "define('WP_HOME', 'https://kilianwordpress.zapto.org/');" >> /var/nfs/wordpress/wp-config-sample.php
echo "define('WP_SITEURL', 'https://kilianwordpress.zapto.org/');" >> /var/nfs/wordpress/wp-config-sample.php