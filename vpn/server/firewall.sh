#!/bin/sh

PRIVATE=10.0.0.0/24
PORT=1194
INTERNET_INTERFACE=eth0

iptables -A INPUT -p tcp --dport $PORT -j ACCEPT
iptables -A INPUT -p udp --dport $PORT -j ACCEPT

iptables -A INPUT -i tun+ -j ACCEPT
iptables -A FORWARD -i tun+ -j ACCEPT
iptables -A INPUT -i tap+ -j ACCEPT
iptables -A FORWARD -i tap+ -j ACCEPT
iptables -A INPUT -i br+ -j ACCEPT
iptables -A FORWARD -i br+ -j ACCEPT

iptables -A OUTPUT -m state --state NEW -o $INTERNET_INTERFACE -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -m state --state NEW -o $INTERNET_INTERFACE -j ACCEPT
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

iptables -t nat -A POSTROUTING -s $PRIVATE -o $INTERNET_INTERFACE -j MASQUERADE
