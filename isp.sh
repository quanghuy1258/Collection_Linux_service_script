#!/bin/bash

EXTERNAL_IFACE="";
INTERNAL_IFACE="";

# Check parameters
if [ -z "$EXTERNAL_IFACE" ] || [ -z "$INTERNAL_IFACE" ]; then
	echo "Check parametes";
	exit 1;
fi;

#Check using sudo or not
if [ $(id -u) -ne 0 ]; then
	echo "Error: Please run as root";
	exit 1;
fi;

cd routing/;
make routing IFACE=$EXTERNAL_IFACE;
cd ../;

echo "===== NAT: Done =====";
read -n1 -r -p "Press any key to continue..." key;

cd static_ip/;
make static_ip IFACE=$INTERNAL_IFACE IP=10.10.231.2 NETMASK=255.255.255.0;
cd ../;

echo "===== Static IP: Done =====";

