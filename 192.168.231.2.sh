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

cd dhcp/server/;
mv 192.168.231.2.dhcpd.conf dhcpd.conf;
make install;
make configure;
make iface_ip IFACE=$IFACE IP=192.168.231.2;
make start;
rm -rf dhcpd.conf;
cd ../../;

read -n1 -r -p "Press any key to continue..." key

cd dns/server/;
make install;
make configure ZONE=huyhy.com;
make start;
cd ../../;
