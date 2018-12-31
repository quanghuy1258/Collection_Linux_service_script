# Using Makefile instead of bash script

SHELL := /bin/bash

# $ make list_targets
# List all possible targets
list_targets:
	@	echo "all ZONE={string}";
	@	echo "list_targets";

# $ sudo make all ZONE={string}
all:
	@	if [ $$(id -u) -ne 0 ]; then                                                                  \
			echo "Error: Please run as root";                                                         \
			exit;                                                                                     \
		fi;                                                                                           \
		if [ -z "$(ZONE)" ]; then                                                                     \
			echo "Error: ZONE arg is not set";                                                        \
			exit;                                                                                     \
		fi;                                                                                           \
		VAR_ZONE=$$(echo "$(ZONE)" | sed -r "s/\.+/./g" | sed -r "s/^\.//" | sed -r "s/\.$$//");      \
		PATH_PWD=$$(pwd);                                                                             \
		if [ ! -f $$PATH_PWD/named.conf.$$VAR_ZONE ]; then                                            \
			echo "Error: File named.conf.$$VAR_ZONE not found";                                       \
			exit;                                                                                     \
		fi;                                                                                           \
		if [ -z "$$(cat $$PATH_PWD/named.conf.$$VAR_ZONE | grep -E "^zone \"$$VAR_ZONE\"")" ]; then   \
			echo "Error: File named.conf.$$VAR_ZONE --> Syntax error";                                \
			exit;                                                                                     \
		fi;                                                                                           \
		if [ ! -f $$PATH_PWD/db.$$VAR_ZONE ]; then                                                    \
			echo "Error: File db.$$VAR_ZONE not found";                                               \
			exit;                                                                                     \
		fi;                                                                                           \
		OS_ID=$$(cat /etc/os-release | grep "^ID=" | cut -c 4-);                                      \
		if [ "$$OS_ID" = "ubuntu" ]; then                                                             \
			if [ -z "$$(apt list --installed | grep "^bind9/")" ]; then                               \
				echo "Installing bind ...";                                                           \
				sudo apt-get -y install bind9;                                                        \
			fi;                                                                                       \
			if [ -z "$$(cat /etc/bind/named.conf.local | grep -E "^zone \"$$VAR_ZONE\"")" ]; then     \
				sudo cat $$PATH_PWD/named.conf.$$VAR_ZONE >> /etc/bind/named.conf.local;              \
			fi;                                                                                       \
			sudo cp $$PATH_PWD/db.$$VAR_ZONE /etc/bind/;                                              \
			if [ -z "$$(systemctl status bind9.service | grep -E "Active: active (running)")" ]; then \
				sudo systemctl start bind9.service;                                                   \
			else                                                                                      \
				sudo systemctl restart bind9.service;                                                 \
			fi;                                                                                       \
			exit;                                                                                     \
		fi;                                                                                           \
		if [ -z "$$OS_ID" ]; then                                                                     \
			echo "Error: OS not supported";                                                           \
		else                                                                                          \
			echo "Error: $$OS_ID OS not supported";                                                   \
		fi;
