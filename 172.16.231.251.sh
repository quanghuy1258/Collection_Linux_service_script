#!/bin/bash

IFACE="";

# Check parameters
if [ -z "$IFACE" ]; then
	echo "Check parametes";
	exit 1;
fi;

#Check using sudo or not
if [ $(id -u) -ne 0 ]; then
	echo "Error: Please run as root";
	exit 1;
fi;

cp easy-rsa/keys/ca.crt mail/server/ssl/cacert.pem;
cp easy-rsa/keys/mail.huyhy.com.crt mail/server/ssl/mail.huyhy.com.crt;
cp easy-rsa/keys/mail.huyhy.com.key mail/server/ssl/mail.huyhy.com.key;
cd mail/server/;
make install;
read -n1 -r -p "Press any key to continue..." key;
make configure_postfix;
read -n1 -r -p "Press any key to continue..." key;
cp amavisd-new/172.16.231.251.50-user amavisd-new/50-user;
make configure_filtering;
read -n1 -r -p "Press any key to continue..." key;
make configure_ssl MYHOSTNAME=mail.huyhy.com;
read -n1 -r -p "Press any key to continue..." key;
make start;
cd ../../;

echo "===== Mail: Done =====";
read -n1 -r -p "Press any key to continue..." key;

cp easy-rsa/keys/ca.crt web/server/www.huyhy.com/cacert.pem;
cp easy-rsa/keys/www.huyhy.com.crt web/server/www.huyhy.com/www.huyhy.com.pem;
cp easy-rsa/keys/www.huyhy.com.key web/server/www.huyhy.com/www.huyhy.com.key;
cp easy-rsa/keys/ca.crt web/server/www.huyhymedia.com/cacert.pem;
cp easy-rsa/keys/www.huyhymedia.com.crt web/server/www.huyhymedia.com/www.huyhymedia.com.pem;
cp easy-rsa/keys/www.huyhymedia.com.key web/server/www.huyhymedia.com/www.huyhymedia.com.key;
cd web/server/;
make install;
read -n1 -r -p "Press any key to continue..." key;
make configure;
read -n1 -r -p "Press any key to continue..." key;
make configure_host CA=cacert HOST=www.huyhy.com;
read -n1 -r -p "Press any key to continue..." key;
make configure_host CA=cacert HOST=www.huyhymedia.com;
read -n1 -r -p "Press any key to continue..." key;
make configure_wordpress NAME=wordpress USER=wordpress PASSWORD=1234567 HOST=www.huyhymedia.com
read -n1 -r -p "Press any key to continue..." key;
make start;
make fix_https CA=cacert CAPATH=../../easy-rsa/keys/ca.crt;
cd ../../;
read -n1 -r -p "Press any key to continue..." key;
cp -r web/server/www.huyhy.com/droot/* /var/www/html/www.huyhy.com/;
cp web/server/wordpress.sql forum.sql;
sed -re "s/database_name_here/forum/g" -i forum.sql;
sed -re "s/username_here/forum/g" -i forum.sql;
sed -re "s/password_here/1234567/g" -i forum.sql;
cat forum.sql | mysql --defaults-extra-file=/etc/mysql/debian.cnf;
rm -rf forum.sql;
mkdir -p /home/forum;
wget https://www.phpbb.com/files/release/phpBB-3.2.5.zip;
unzip phpBB-3.2.5.zip;
cp -r phpBB3/* /home/forum/;
chown -R www-data:www-data /home/forum/;
chmod -R 755 /home/forum/;
rm -rf phpBB-3.2.5.zip phpBB3;

echo "===== Web: Done =====";
read -n1 -r -p "Press any key to continue..." key;

cd ssh/server/;
cp 172.16.231.251.sshd_config sshd_config;
make install;
read -n1 -r -p "Press any key to continue..." key;
make configure;
read -n1 -r -p "Press any key to continue..." key;
make start;
cd ../../;

echo "===== SSH: Done =====";
read -n1 -r -p "Press any key to continue..." key;

cd static_ip/;
make static IFACE=$IFACE IP=172.16.231.251 NETMASK=255.255.255.0 GATEWAY=172.16.231.1 DNS="8.8.8.8 8.8.4.4"
cd ../;

echo "===== Set static ip: Done =====";
