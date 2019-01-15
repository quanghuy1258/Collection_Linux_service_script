SHELL    := /bin/bash
PATH_PWD := $(shell pwd)
OS_ID    := $(shell cat /etc/os-release | grep "^ID=" | cut -c 4-)

help:
	@	echo "- Show help:                  $$ make help"
	@	echo "- Install dependencies:   (1) $$ sudo make install"
	@	echo "- Uninstall dependencies:     $$ sudo make uninstall"
	@	echo "- Configure:              (2) $$ sudo make configure"
	@	echo "- Start:                  (3) $$ sudo make start IFACE={string}"
	@	echo "RECOMMEND: (1) -> (2) -> (3)"

install:
	@	if [ $$(id -u) -ne 0 ]; then                                    \
			echo "Error: Please run as root";                           \
			exit;                                                       \
		fi;                                                             \
		if [ "$(OS_ID)" = "ubuntu" ]; then                              \
			if [ -z "$$(apt list --installed | grep "^squid/")" ]; then \
				echo "===== Install squid =====";                       \
				apt-get -y install squid;                               \
			fi;                                                         \
			echo "===== Done =====";                                    \
			exit;                                                       \
		fi;                                                             \
		if [ -z "$(OS_ID)" ]; then                                      \
			echo "Error: OS not supported";                             \
		else                                                            \
			echo "Error: $(OS_ID) OS not supported";                    \
		fi;

uninstall:
	@	if [ $$(id -u) -ne 0 ]; then                                                        \
			echo "Error: Please run as root";                                               \
			exit;                                                                           \
		fi;                                                                                 \
		if [ "$(OS_ID)" = "ubuntu" ]; then                                                  \
			if [ ! -z "$$(systemctl status squid.service | grep "Active: active ")" ]; then \
				echo "===== Stop squid.service =====";                                      \
				systemctl stop squid.service;                                               \
			fi;                                                                             \
			if [ ! -z "$$(apt list --installed | grep "^squid/")" ]; then                   \
				echo "===== Uninstall squid =====";                                         \
				apt-get -y purge squid;                                                     \
			fi;                                                                             \
			echo "===== Done =====";                                                        \
			exit;                                                                           \
		fi;                                                                                 \
		if [ -z "$(OS_ID)" ]; then                                                          \
			echo "Error: OS not supported";                                                 \
		else                                                                                \
			echo "Error: $(OS_ID) OS not supported";                                        \
		fi;

configure:
	@	if [ $$(id -u) -ne 0 ]; then                                                                                     \
			echo "Error: Please run as root";                                                                            \
			exit;                                                                                                        \
		fi;                                                                                                              \
		if [ ! -f "$(PATH_PWD)/badsite.acl" ]; then                                                                      \
			echo "Error: File badsite.acl is not found";                                                                 \
			exit;                                                                                                        \
		fi;                                                                                                              \
		if [ -z "$$(cat $(PATH_PWD)/badsite.acl)" ]; then                                                                \
			echo "Warning: File badsite.acl is empty";                                                                   \
			read -r -p "Continue? [y/N] " response;                                                                      \
			if [ -z "$$(echo $$response | grep -E "^([yY][eE][sS]|y)$$")" ]; then                                        \
				exit;                                                                                                    \
			fi;                                                                                                          \
		fi;                                                                                                              \
		if [ "$(OS_ID)" = "ubuntu" ]; then                                                                               \
			if [ -f "/etc/squid/badsite.acl" ] && [ ! -f "$(PATH_PWD)/badsite.acl.bak" ]; then                           \
				cp /etc/squid/badsite.acl $(PATH_PWD)/badsite.acl.bak;                                                   \
			fi;                                                                                                          \
			if [ -f "$(PATH_PWD)/badsite.acl.bak" ]; then                                                                \
				cp $(PATH_PWD)/badsite.acl.bak /etc/squid/badsite.acl;                                                   \
			fi;                                                                                                          \
			cat $(PATH_PWD)/badsite.acl >>/etc/squid/badsite.acl;                                                        \
			if [ ! -f "$(PATH_PWD)/squid.conf.bak" ]; then                                                               \
				cp /etc/squid/squid.conf $(PATH_PWD)/squid.conf.bak;                                                     \
			fi;                                                                                                          \
			cp $(PATH_PWD)/squid.conf.bak /etc/squid/squid.conf;                                                         \
			if [ -z "$$(cat /etc/squid/squid.conf | grep "acl bad_sites dstdomain \"/etc/squid/badsites.acl\"")" ]; then \
				sed -i "1i\acl bad_sites dstdomain \"\/etc\/squid\/badsites.acl\"" /etc/squid/squid.conf;                \
			fi;                                                                                                          \
			if [ -z "$$(cat /etc/squid/squid.conf | grep "^http_access allow all")" ]; then                              \
				lastline=$$(cat /etc/squid/squid.conf | grep "^http_access" | tail -n 1);                                \
				sed -i "/$${lastline}/a\http_access allow all" /etc/squid/squid.conf;                                    \
			fi;                                                                                                          \
			if [ -z "$$(cat /etc/squid/squid.conf | grep "^http_access deny bad_sites")" ]; then                         \
				lastline=$$(cat /etc/squid/squid.conf | grep "^http_access" | tail -n 1);                                \
				sed -i "/$${lastline}/a\http_access deny bad_sites" /etc/squid/squid.conf;                               \
			fi;                                                                                                          \
			if [ -z "$$(cat /etc/squid/squid.conf | grep "^http_port 3128 intercept")" ]; then                           \
				sed -i "/^http_port 3128/c\http_port 3128 intercept" /etc/squid/squid.conf;                              \
			fi;                                                                                                          \
			echo "===== Done =====";                                                                                     \
			exit;                                                                                                        \
		fi;                                                                                                              \
		if [ -z "$(OS_ID)" ]; then                                                                                       \
			echo "Error: OS not supported";                                                                              \
		else                                                                                                             \
			echo "Error: $(OS_ID) OS not supported";                                                                     \
		fi;

start:
	@	if [ $$(id -u) -ne 0 ]; then                                                                 \
			echo "Error: Please run as root";                                                        \
			exit;                                                                                    \
		fi;                                                                                          \
		if [ -z "$(IFACE)" ]; then                                                                   \
			echo "Error: IFACE arg is not set";                                                      \
			exit;                                                                                    \
		fi;                                                                                          \
		if [ "$(OS_ID)" = "ubuntu" ]; then                                                           \
			echo 1 >/proc/sys/net/ipv4/ip_forward;                                                   \
			iptables -t nat -A PREROUTING -i $(IFACE) -p tcp --dport 80  -j REDIRECT --to-port 3128; \
			iptables -t nat -A PREROUTING -i $(IFACE) -p tcp --dport 443 -j REDIRECT --to-port 3128; \
			if [ -z "$$(systemctl status squid.service | grep "Active: active ")" ]; then            \
				echo "===== Start squid.service =====";                                              \
				systemctl start squid.service;                                                       \
			else                                                                                     \
				echo "===== Restart squid.service =====";                                            \
				systemctl restart squid.service;                                                     \
			fi;                                                                                      \
			echo "===== Done =====";                                                                 \
			exit;                                                                                    \
		fi;                                                                                          \
		if [ -z "$(OS_ID)" ]; then                                                                   \
			echo "Error: OS not supported";                                                          \
		else                                                                                         \
			echo "Error: $(OS_ID) OS not supported";                                                 \
		fi;
