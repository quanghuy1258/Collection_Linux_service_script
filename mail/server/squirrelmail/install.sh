#!/bin/bash

echo "===== Install squirrelmail =====";

if [ $(id -u) -ne 0 ]; then
	echo "Error: Please run as root";
	exit 1;
fi;

OS_ID=$(cat /etc/os-release | grep "^ID=" | cut -c 4-);

if [ "$OS_ID" = "ubuntu" ]; then
	echo "Info: Install utilities packages";
	if [ -z "$(apt list --installed | grep "^wget/")" ]; then
		echo "Info: Install wget";
		apt-get -y install wget;
	fi;
	if [ -z "$(apt list --installed | grep "^tar/")" ]; then
		echo "Info: Install tar";
		apt-get -y install tar;
	fi;

	echo "Info: Install required packages";
	if [ -z "$(apt list --installed | grep "^apache2/")" ]; then
		echo "Info: Install apache2";
		apt-get -y install apache2;
	fi;
	if [ -z "$(apt list --installed | grep "^php/")" ]; then
		echo "Info: Install php";
		apt-get -y install php;
	fi;
	echo "Info: Enable PHP in Apache2";
	a2enmod php*;

	echo "Info: Install squirrelmail";
	wget https://sourceforge.net/projects/squirrelmail/files/stable/1.4.22/squirrelmail-webmail-1.4.22.tar.gz;
	tar -xf squirrelmail-webmail-1.4.22.tar.gz;
	rm -rf squirrelmail-webmail-1.4.22.tar.gz;
	echo "===== Done =====";
	exit 0;
fi;
if [ -z "$OS_ID" ]; then
	echo "Error: OS not supported";
else
	echo "Error: $OS_ID OS not supported";
fi
exit 1;
