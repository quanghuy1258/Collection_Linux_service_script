SHELL    := /bin/bash
PATH_PWD := $(shell pwd)
OS_ID    := $(shell cat /etc/os-release | grep "^ID=" | cut -c 4-)

help:
	@	echo "- Show help:                  $$ make help"
	@	echo "- Install dependencies:   (1) $$ sudo make install"
	@	echo "- Uninstall dependencies:     $$ sudo make uninstall"
	@	echo "- Configure:              (2) $$ sudo make configure ZONE={string}"
	@	echo "- Start service:          (3) $$ sudo make start"
	@	echo "RECOMMEND: (1) -> (2) -> (3)"

install:
	@	if [ $$(id -u) -ne 0 ]; then                                    \
			echo "Error: Please run as root";                           \
			exit;                                                       \
		fi;                                                             \
		if [ "$(OS_ID)" = "ubuntu" ]; then                              \
			if [ -z "$$(apt list --installed | grep "^bind9/")" ]; then \
				echo "===== Install bind9 =====";                       \
				apt-get -y install bind9;                               \
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
			if [ ! -z "$$(systemctl status bind9.service | grep "Active: active ")" ]; then \
				echo "===== Stop bind9.service =====";                                      \
				systemctl stop bind9.service;                                               \
			fi;                                                                             \
			if [ ! -z "$$(apt list --installed | grep "^bind9/")" ]; then                   \
				echo "===== Uninstall bind9 =====";                                         \
				apt-get -y purge bind9;                                                     \
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
	@	if [ $$(id -u) -ne 0 ]; then                                                                 \
			echo "Error: Please run as root";                                                        \
			exit;                                                                                    \
		fi;                                                                                          \
		if [ -z "$(ZONE)" ]; then                                                                    \
			echo "Error: ZONE arg is not set";                                                       \
			exit;                                                                                    \
		fi;                                                                                          \
		VAR_ZONE=$$(echo "$(ZONE)" | sed -r "s/\.+/./g" | sed -r "s/^\.//" | sed -r "s/\.$$//");     \
		if [ ! -f $(PATH_PWD)/named.conf.$$VAR_ZONE ]; then                                          \
			echo "Error: File named.conf.$$VAR_ZONE not found";                                      \
			exit;                                                                                    \
		fi;                                                                                          \
		if [ -z "$$(cat $(PATH_PWD)/named.conf.$$VAR_ZONE | grep -E "^zone \"$$VAR_ZONE\"")" ]; then \
			echo "Error: File named.conf.$$VAR_ZONE --> Syntax error";                               \
			exit;                                                                                    \
		fi;                                                                                          \
		if [ ! -f $(PATH_PWD)/db.$$VAR_ZONE ]; then                                                  \
			echo "Error: File db.$$VAR_ZONE not found";                                              \
			exit;                                                                                    \
		fi;                                                                                          \
		if [ "$(OS_ID)" = "ubuntu" ]; then                                                           \
			if [ -z "$$(cat /etc/bind/named.conf.local | grep -E "^zone \"$$VAR_ZONE\"")" ]; then    \
				cat $(PATH_PWD)/named.conf.$$VAR_ZONE >> /etc/bind/named.conf.local;                 \
			fi;                                                                                      \
			cp $(PATH_PWD)/db.$$VAR_ZONE /etc/bind/;                                                 \
			echo "===== Done =====";                                                                 \
			exit;                                                                                    \
		fi;                                                                                          \
		if [ -z "$(OS_ID)" ]; then                                                                   \
			echo "Error: OS not supported";                                                          \
		else                                                                                         \
			echo "Error: $(OS_ID) OS not supported";                                                 \
		fi;

start:
	@	if [ $$(id -u) -ne 0 ]; then                                                      \
			echo "Error: Please run as root";                                             \
			exit;                                                                         \
		fi;                                                                               \
		if [ "$(OS_ID)" = "ubuntu" ]; then                                                \
			if [ -z "$$(systemctl status bind9.service | grep "Active: active ")" ]; then \
				echo "===== Start bind9.service =====";                                   \
				sudo systemctl start bind9.service;                                       \
			else                                                                          \
				echo "===== Restart bind9.service =====";                                 \
				sudo systemctl restart bind9.service;                                     \
			fi;                                                                           \
			echo "===== Done =====";                                                      \
			exit;                                                                         \
		fi;                                                                               \
		if [ -z "$(OS_ID)" ]; then                                                        \
			echo "Error: OS not supported";                                               \
		else                                                                              \
			echo "Error: $(OS_ID) OS not supported";                                      \
		fi;

