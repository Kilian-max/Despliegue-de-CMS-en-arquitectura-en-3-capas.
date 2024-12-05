# Actualizar el sistema
apt-get update && apt-get upgrade -y

# Instalar MySQL Server
apt-get install mysql-server -y

# Crear base de datos y usuario
sed -i "s/bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf
systemctl restart mysql

mysql <<EOF
        CREATE DATABASE wordpress;
        CREATE USER 'kilian'@'%' IDENTIFIED BY '1234';
        GRANT ALL PRIVILEGES ON wordpress.* TO 'kilian'@'%';
        FLUSH PRIVILEGES;
EOF

systemctl restart mysql