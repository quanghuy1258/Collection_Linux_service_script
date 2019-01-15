#!/bin/sh

modprobe tun
modprobe bridge

echo 1 > /proc/sys/net/ipv4/ip_forward
