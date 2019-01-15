#!/bin/bash

PUBLIC_IFACE="";
DMZ_IFACE="";
INTERNAL_IFACE="";

# Check parameters
if [ -z "$PUBLIC_IFACE" ] || [ -z "$DMZ_IFACE" ] || [ -z "$INTERNAL_IFACE" ]; then
	echo "Check parametes";
	exit 1;
fi;

#Check using sudo or not
if [ $(id -u) -ne 0 ]; then
	echo "Error: Please run as root";
	exit 1;
fi;

cd static_ip/;
make static IFACE=$PUBLIC_IFACE IP=10.10.231.1 NETMASK=255.255.255.0 GATEWAY=10.10.231.2 DNS="8.8.8.8 8.8.4.4";
make static IFACE=$DMZ_IFACE IP=172.16.231.1 NETMASK=255.255.255.0;
make static IFACE=$INTERNAL_IFACE IP=192.168.231.1 NETMASK=255.255.255.0;
cd ../;

echo "===== Set static ip: Done =====";
read -n1 -r -p "Press any key to continue..." key;

echo 1 > /proc/sys/net/ipv4/ip_forward;

echo "===== Enable ip forward: Done =====";
read -n1 -r -p "Press any key to continue..." key;

# Delete old iptables rules
# and temporarily block all traffic.
iptables -P OUTPUT DROP;
iptables -P INPUT DROP;
iptables -P FORWARD DROP;
iptables -F;

# Set default policies
iptables -P OUTPUT ACCEPT;
iptables -P INPUT DROP;
iptables -P FORWARD DROP;

# Allow local loopback
iptables -A INPUT -i lo -s 127.0.0.0/8 -d 127.0.0.0/8 -j ACCEPT;

# Allow incoming pings
iptables -A INPUT -i $PUBLIC_IFACE   -p icmp -d 10.10.231.1   -j ACCEPT;
iptables -A INPUT -i $DMZ_IFACE      -p icmp -d 172.16.231.1  -j ACCEPT;
iptables -A INPUT -i $INTERNAL_IFACE -p icmp -d 192.168.231.1 -j ACCEPT;

# Allow established and related packet
iptables -A INPUT   -m state --state ESTABLISHED,RELATED -j ACCEPT;
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT;

# Allow forward DMZ and Internal to Public
iptables -A FORWARD -i $DMZ_IFACE      -o $PUBLIC_IFACE -j ACCEPT;
iptables -A FORWARD -i $INTERNAL_IFACE -o $PUBLIC_IFACE -j ACCEPT;

# Allow forward Internal to DMZ
iptables -A FORWARD -i $INTERNAL_IFACE -o $DMZ_IFACE    -j ACCEPT;

echo "===== Basic firewall: Done =====";
read -n1 -r -p "Press any key to continue..." key;

cd vpn/server;
make install;
read -n1 -r -p "Press any key to continue..." key;
make init;
read -n1 -r -p "Press any key to continue..." key;
make server;
read -n1 -r -p "Press any key to continue..." key;
sed -re "s/INTERNET_INTERFACE=.*/INTERNET_INTERFACE=$INTERNAL_IFACE/g" -i 10.10.231.1.firewall.sh;
cp 10.10.231.1.firewall.sh firewall.sh;
make routing_firewall;
read -n1 -r -p "Press any key to continue..." key;
make add_tap BR=br0 TAP=tap0 ETH=$INTERNAL_IFACE ETH_IP=192.168.231.1 ETH_NETMASK=255.255.255.0 ETH_BROADCAST=192.168.231.255
read -n1 -r -p "Press any key to continue..." key;
cp 10.10.231.1.server.conf server.conf;
make start;
cd ../../;

echo "===== VPN: Done =====";
read -n1 -r -p "Press any key to continue..." key;

# Allow services
# DMZ
iptables -t nat -A PREROUTING -p tcp --dport 80  -i $PUBLIC_IFACE -j DNAT --to-destination 172.16.231.251:80;
iptables -t nat -A PREROUTING -p tcp --dport 443 -i $PUBLIC_IFACE -j DNAT --to-destination 172.16.231.251:443;
iptables -t nat -A PREROUTING -p tcp --dport 25  -i $PUBLIC_IFACE -j DNAT --to-destination 172.16.231.251:25;
iptables -t nat -A PREROUTING -p tcp --dport 110 -i $PUBLIC_IFACE -j DNAT --to-destination 172.16.231.251:110;
iptables -t nat -A PREROUTING -p tcp --dport 143 -i $PUBLIC_IFACE -j DNAT --to-destination 172.16.231.251:143;
iptables -t nat -A PREROUTING -p tcp --dport 465 -i $PUBLIC_IFACE -j DNAT --to-destination 172.16.231.251:465;
iptables -t nat -A PREROUTING -p tcp --dport 993 -i $PUBLIC_IFACE -j DNAT --to-destination 172.16.231.251:993;
iptables -t nat -A PREROUTING -p tcp --dport 995 -i $PUBLIC_IFACE -j DNAT --to-destination 172.16.231.251:995;
iptables -t nat -A PREROUTING -p tcp --dport 20  -i $PUBLIC_IFACE -j DNAT --to-destination 172.16.231.251:20;
iptables -t nat -A PREROUTING -p tcp --dport 21  -i $PUBLIC_IFACE -j DNAT --to-destination 172.16.231.251:21;
iptables -A FORWARD -i $PUBLIC_IFACE -o $DMZ_IFACE -p tcp -d 172.16.231.251 --dport 80  -j ACCEPT;
iptables -A FORWARD -i $PUBLIC_IFACE -o $DMZ_IFACE -p tcp -d 172.16.231.251 --dport 443 -j ACCEPT;
iptables -A FORWARD -i $PUBLIC_IFACE -o $DMZ_IFACE -p tcp -d 172.16.231.251 --dport 25  -j ACCEPT;
iptables -A FORWARD -i $PUBLIC_IFACE -o $DMZ_IFACE -p tcp -d 172.16.231.251 --dport 110 -j ACCEPT;
iptables -A FORWARD -i $PUBLIC_IFACE -o $DMZ_IFACE -p tcp -d 172.16.231.251 --dport 143 -j ACCEPT;
iptables -A FORWARD -i $PUBLIC_IFACE -o $DMZ_IFACE -p tcp -d 172.16.231.251 --dport 465 -j ACCEPT;
iptables -A FORWARD -i $PUBLIC_IFACE -o $DMZ_IFACE -p tcp -d 172.16.231.251 --dport 993 -j ACCEPT;
iptables -A FORWARD -i $PUBLIC_IFACE -o $DMZ_IFACE -p tcp -d 172.16.231.251 --dport 995 -j ACCEPT;
iptables -A FORWARD -i $PUBLIC_IFACE -o $DMZ_IFACE -p tcp -d 172.16.231.251 --dport 20  -j ACCEPT;
iptables -A FORWARD -i $PUBLIC_IFACE -o $DMZ_IFACE -p tcp -d 172.16.231.251 --dport 21  -j ACCEPT;
# Internal network
iptables -t nat -A PREROUTING -p tcp --dport 53  -i $PUBLIC_IFACE -j DNAT --to-destination 192.168.231.2:53;
iptables -t nat -A PREROUTING -p udp --dport 53  -i $PUBLIC_IFACE -j DNAT --to-destination 192.168.231.2:53;
iptables -A FORWARD -i $PUBLIC_IFACE -o $INTERNAL_IFACE -p tcp -d 172.16.231.251 --dport 53 -j ACCEPT;

echo "===== Allow services: Done =====";
read -n1 -r -p "Press any key to continue..." key;

cd routing/;
make routing IFACE=$PUBLIC_IFACE;
cd ../;

echo "===== NAT: Done =====";

