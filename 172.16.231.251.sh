#!/bin/bash

WP_NAME=""
WP_USER=""
WP_PASSWORD=""

# Check parameters
if [ -z "$WP_NAME" ] || [ -z "$WP_USER" ] || [ -z "$WP_PASSWORD" ]; then
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
cp easy-rsa/keys/ca.crt web/server/cacert.pem;
cp easy-rsa/keys/www.huyhymedia.com.crt web/server/www.huyhymedia.com/www.huyhymedia.com.pem;
cp easy-rsa/keys/www.huyhymedia.com.key web/server/www.huyhymedia.com/www.huyhymedia.com.key;
cd web/server/;
make install;
read -n1 -r -p "Press any key to continue..." key;
make configure;
make configure_host CA=cacert HOST=www.huyhy.com;
read -n1 -r -p "Press any key to continue..." key;
make configure_host CA=cacert HOST=www.huyhymedia.com;
read -n1 -r -p "Press any key to continue..." key;
make configure_wordpress NAME=$WP_NAME USER=$WP_USER PASSWORD=$WP_PASSWORD HOST=www.huyhymedia.com
read -n1 -r -p "Press any key to continue..." key;
make start;
cd ../../;

echo "===== Web: Done =====";
read -n1 -r -p "Press any key to continue..." key;
