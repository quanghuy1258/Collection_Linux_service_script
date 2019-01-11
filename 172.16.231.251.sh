#!/bin/bash

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
make configure_postfix;
read -n1 -r -p "Press any key to continue..." key;
cp amavisd-new/172.16.231.251.50-user amavisd-new/50-user;
make configure_filtering;
read -n1 -r -p "Press any key to continue..." key;
make configure_ssl MYHOSTNAME=mail.huyhy.com;
read -n1 -r -p "Press any key to continue..." key;
make start;

echo "===== Mail: Done =====";
read -n1 -r -p "Press any key to continue..." key;
