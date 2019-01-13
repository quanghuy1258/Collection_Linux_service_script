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

read -n1 -r -p "Press any key to continue..." key;
echo "===== Set static ip: Done =====";

# Delete old iptables rules
# and temporarily block all traffic.
iptables -P OUTPUT DROP;
iptables -P INPUT DROP;
iptables -P FORWARD DROP;
iptables -F;

# Set default policies
iptables -P OUTPUT ACCEPT;
iptables -P INPUT ACCEPT;
iptables -P FORWARD DROP;

# Block ssh from outside
iptables -A INPUT -p tcp --dport 22 -s 10.10.231.0/24 -j DROP;
iptables -A INPUT -p udp --dport 22 -s 10.10.231.0/24 -j DROP;

# Allow services
# DMZ
iptables -A FORWARD -i $DMZ_IFACE -o $PUBLIC_IFACE -s 172.16.231.0/24 -j ACCEPT;
iptables -t nat -A PREROUTING -p tcp --dport 80  -j DNAT --to-destination 172.16.231.251:80;
iptables -t nat -A PREROUTING -p tcp --dport 443 -j DNAT --to-destination 172.16.231.251:443;
iptables -t nat -A PREROUTING -p tcp --dport 25  -j DNAT --to-destination 172.16.231.251:25;
iptables -t nat -A PREROUTING -p tcp --dport 110 -j DNAT --to-destination 172.16.231.251:110;
iptables -t nat -A PREROUTING -p tcp --dport 143 -j DNAT --to-destination 172.16.231.251:143;
iptables -t nat -A PREROUTING -p tcp --dport 465 -j DNAT --to-destination 172.16.231.251:465;
iptables -t nat -A PREROUTING -p tcp --dport 993 -j DNAT --to-destination 172.16.231.251:993;
iptables -t nat -A PREROUTING -p tcp --dport 995 -j DNAT --to-destination 172.16.231.251:995;
iptables -t nat -A PREROUTING -p tcp --dport 20  -j DNAT --to-destination 172.16.231.251:20;
iptables -t nat -A PREROUTING -p tcp --dport 21  -j DNAT --to-destination 172.16.231.251:21;
iptables -A FORWARD -i $PUBLIC_IFACE -o $DMZ_IFACE -p tcp --dport 80  -j ACCEPT;
iptables -A FORWARD -i $PUBLIC_IFACE -o $DMZ_IFACE -p tcp --dport 443 -j ACCEPT;
iptables -A FORWARD -i $PUBLIC_IFACE -o $DMZ_IFACE -p tcp --dport 25  -j ACCEPT;
iptables -A FORWARD -i $PUBLIC_IFACE -o $DMZ_IFACE -p tcp --dport 110 -j ACCEPT;
iptables -A FORWARD -i $PUBLIC_IFACE -o $DMZ_IFACE -p tcp --dport 143 -j ACCEPT;
iptables -A FORWARD -i $PUBLIC_IFACE -o $DMZ_IFACE -p tcp --dport 465 -j ACCEPT;
iptables -A FORWARD -i $PUBLIC_IFACE -o $DMZ_IFACE -p tcp --dport 993 -j ACCEPT;
iptables -A FORWARD -i $PUBLIC_IFACE -o $DMZ_IFACE -p tcp --dport 995 -j ACCEPT;
iptables -A FORWARD -i $PUBLIC_IFACE -o $DMZ_IFACE -p tcp --dport 20  -j ACCEPT;
iptables -A FORWARD -i $PUBLIC_IFACE -o $DMZ_IFACE -p tcp --dport 21  -j ACCEPT;
# Internal network
iptables -A FORWARD -i $INTERNAL_IFACE -o $PUBLIC_IFACE -s 192.168.231.0/24 -j ACCEPT;
iptables -t nat -A PREROUTING -p tcp --dport 53  -j DNAT --to-destination 192.168.231.2:53;
iptables -t nat -A PREROUTING -p udp --dport 53  -j DNAT --to-destination 192.168.231.2:53;
iptables -A FORWARD -i $PUBLIC_IFACE -o $INTERNAL_IFACE -p tcp --dport 53 -j ACCEPT;

# DMZ and Internal network
iptables -A FORWARD -i $DMZ_IFACE -o $INTERNAL_IFACE -s 172.16.231.0/24  -j ACCEPT;
iptables -A FORWARD -i $INTERNAL_IFACE -o $DMZ_IFACE -s 192.168.231.0/24 -j ACCEPT;

cd routing/;
make routing IFACE=$PUBLIC_IFACE;
cd ../;

echo "===== Firewall + NAT: Done =====";

