#!/bin/bash

echo "===== Uninstall squirrelmail =====";

if [ $(id -u) -ne 0 ]; then
	echo "Error: Please run as root";
	exit 1;
fi;

OS_ID=$(cat /etc/os-release | grep "^ID=" | cut -c 4-);

if [ "$OS_ID" = "ubuntu" ]; then
	rm -rf /var/www/html/squirrelmail/;
	echo "Info: Done";
	exit 0;
fi;
if [ -z "$OS_ID" ]; then
	echo "Error: OS not supported";
else
	echo "Error: $OS_ID OS not supported";
fi
exit 1;
