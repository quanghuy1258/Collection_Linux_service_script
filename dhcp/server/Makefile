SHELL    := /bin/bash
PATH_PWD := $(shell pwd)
OS_ID    := $(shell cat /etc/os-release | grep "^ID=" | cut -c 4-)

help:
	@	echo "- Show help:                  $$ make help"
	@	echo "- Install dependencies:   (1) $$ sudo make install"
	@	echo "- Uninstall dependencies:     $$ sudo make uninstall"
	@	echo "- Configure:              (2) $$ sudo make configure"
	@	echo "- Start service:          (3) $$ sudo make start"
	@	echo "RECOMMEND: (1) -> (2) -> (3)"

install:
	@	if [ $$(id -u) -ne 0 ]; then                                              \
			echo "Error: Please run as root";                                     \
			exit;                                                                 \
		fi;                                                                       \
		if [ "$(OS_ID)" = "ubuntu" ]; then                                        \
			if [ -z "$$(apt list --installed | grep "^isc-dhcp-server/")" ]; then \
				echo "===== Install isc-dhcp-server =====";                       \
				apt-get -y install isc-dhcp-server;                               \
			fi;                                                                   \
			echo "===== Done =====";                                              \
			exit;                                                                 \
		fi;                                                                       \
		if [ -z "$(OS_ID)" ]; then                                                \
			echo "Error: OS not supported";                                       \
		else                                                                      \
			echo "Error: $(OS_ID) OS not supported";                              \
		fi;

uninstall:
	@	if [ $$(id -u) -ne 0 ]; then                                                                  \
			echo "Error: Please run as root";                                                         \
			exit;                                                                                     \
		fi;                                                                                           \
		if [ "$(OS_ID)" = "ubuntu" ]; then                                                            \
			if [ ! -z "$$(systemctl status isc-dhcp-server.service | grep "Active: active ")" ]; then \
				echo "===== Stop isc-dhcp-server.service =====";                                      \
				systemctl stop isc-dhcp-server.service;                                               \
			fi;                                                                                       \
			if [ ! -z "$$(apt list --installed | grep "^isc-dhcp-server/")" ]; then                   \
				echo "===== Uninstall isc-dhcp-server =====";                                         \
				apt-get -y purge isc-dhcp-server;                                                     \
			fi;                                                                                       \
			echo "===== Done =====";                                                                  \
			exit;                                                                                     \
		fi;                                                                                           \
		if [ -z "$(OS_ID)" ]; then                                                                    \
			echo "Error: OS not supported";                                                           \
		else                                                                                          \
			echo "Error: $(OS_ID) OS not supported";                                                  \
		fi;

configure:
	@	if [ $$(id -u) -ne 0 ]; then                                                                          \
			echo "Error: Please run as root";                                                                 \
			exit;                                                                                             \
		fi;                                                                                                   \
		if [ ! -f $(PATH_PWD)/dhcpd.conf ]; then                                                              \
			echo "Error: File dhcpd.conf not found";                                                          \
			exit;                                                                                             \
		fi;                                                                                                   \
		if [ ! -z "$$(shasum $(PATH_PWD)/dhcpd.conf | grep d054cee68719a876ca97c73fe8878ac4bb30bed0)" ]; then \
			echo "Error: Please modify dhcpd.conf file";                                                      \
			exit;                                                                                             \
		fi;                                                                                                   \
		if [ "$(OS_ID)" = "ubuntu" ]; then                                                                    \
			if [ -f /etc/dhcp/dhcpd.conf ] && [ ! -f /etc/dhcp/dhcpd.conf.bak ]; then                         \
				cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.bak;                                             \
			fi;                                                                                               \
			cp $(PATH_PWD)/dhcpd.conf /etc/dhcp/dhcpd.conf;                                                   \
			echo "===== Done =====";                                                                          \
			exit;                                                                                             \
		fi;                                                                                                   \
		if [ -z "$(OS_ID)" ]; then                                                                            \
			echo "Error: OS not supported";                                                                   \
		else                                                                                                  \
			echo "Error: $(OS_ID) OS not supported";                                                          \
		fi;

start:
	@	if [ $$(id -u) -ne 0 ]; then                                                                \
			echo "Error: Please run as root";                                                       \
			exit;                                                                                   \
		fi;                                                                                         \
		if [ "$(OS_ID)" = "ubuntu" ]; then                                                          \
			if [ -z "$$(systemctl status isc-dhcp-server.service | grep "Active: active ")" ]; then \
				echo "===== Start isc-dhcp-server.service =====";                                   \
				sudo systemctl start isc-dhcp-server.service;                                       \
			else                                                                                    \
				echo "===== Restart isc-dhcp-server.service =====";                                 \
				sudo systemctl restart isc-dhcp-server.service;                                     \
			fi;                                                                                     \
			echo "===== Done =====";                                                                \
			exit;                                                                                   \
		fi;                                                                                         \
		if [ -z "$(OS_ID)" ]; then                                                                  \
			echo "Error: OS not supported";                                                         \
		else                                                                                        \
			echo "Error: $(OS_ID) OS not supported";                                                \
		fi;

