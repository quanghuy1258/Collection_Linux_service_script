SHELL    := /bin/bash
PATH_PWD := $(shell pwd)
OS_ID    := $(shell cat /etc/os-release | grep "^ID=" | cut -c 4-)

help:
	@	echo "- Show help:         $$ make help"
	@	echo "- Set static ip: (1) $$ sudo make static IFACE={string} IP={string} NETMASK={string} GATEWAY={string} DNS={string}"
	@	echo "RECOMMEND: (1)"

static:
	@	if [ $$(id -u) -ne 0 ]; then                                                                                      \
			echo "Error: Please run as root";                                                                             \
			exit;                                                                                                         \
		fi;                                                                                                               \
		if [ -z "$(IFACE)" ]; then                                                                                        \
			echo "Error: IFACE arg is not set";                                                                           \
			exit;                                                                                                         \
		fi;                                                                                                               \
		if [ -z "$(IP)" ]; then                                                                                           \
			echo "Error: IP arg is not set";                                                                              \
			exit;                                                                                                         \
		fi;                                                                                                               \
		if [ -z "$(NETMASK)" ]; then                                                                                      \
			echo "Error: NETMASK arg is not set";                                                                         \
			exit;                                                                                                         \
		fi;                                                                                                               \
		if [ -z "$(GATEWAY)" ]; then                                                                                      \
			echo "Error: GATEWAY arg is not set";                                                                         \
			exit;                                                                                                         \
		fi;                                                                                                               \
		if [ -z "$(DNS)" ]; then                                                                                          \
			echo "Error: DNS arg is not set";                                                                             \
			exit;                                                                                                         \
		fi;                                                                                                               \
		echo "Check your args: IFACE=$(IFACE), IP=$(IP), NETMASK=$(NETMASK), GATEWAY=$(GATEWAY), DNS=$(DNS)";             \
		echo "Warning: Example -> IFACE={string}, IP=x.x.x.x, NETMASK=x.x.x.x, GATEWAY=x.x.x.x, DNS=\"x.x.x.x y.y.y.y\""; \
		read -r -p "Continue? [y/N] " response;                                                                           \
		if [ -z "$$(echo $$response | grep -E "^([yY][eE][sS]|y)$$")" ]; then                                             \
			exit;                                                                                                         \
		fi;                                                                                                               \
		if [ "$(OS_ID)" = "ubuntu" ]; then                                                                                \
			if [ -z "$$(apt list --installed | grep "^ifupdown/")" ]; then                                                \
				echo "===== Install ifupdown =====";                                                                      \
				apt-get -y install ifupdown;                                                                              \
			fi;                                                                                                           \
			if [ ! -f $(PATH_PWD)/interfaces.bak ]; then                                                                  \
				cp /etc/network/interfaces $(PATH_PWD)/interfaces.bak;                                                    \
			fi;                                                                                                           \
			rm -rf /etc/network/interfaces;                                                                               \
			cp $(PATH_PWD)/interfaces.bak /etc/network/interfaces;                                                        \
			if [ -z "$$(cat /etc/network/interfaces | grep "^auto $(IFACE)$$")" ]; then                                   \
				printf "\n" >>/etc/network/interfaces;                                                                    \
				printf "auto $(IFACE)\n" >>/etc/network/interfaces;                                                       \
				printf "iface $(IFACE) inet static\n" >>/etc/network/interfaces;                                          \
				printf "address $(IP)\n" >>/etc/network/interfaces;                                                       \
				printf "netmask $(NETMASK)\n" >>/etc/network/interfaces;                                                  \
				printf "gateway $(GATEWAY)\n" >>/etc/network/interfaces;                                                  \
				printf "dns-nameservers $(DNS)\n" >>/etc/network/interfaces;                                              \
				printf "\n" >>/etc/network/interfaces;                                                                    \
				ip addr flush $(IFACE);                                                                                   \
				ifdown $(IFACE);                                                                                          \
				ifup $(IFACE);                                                                                            \
				if [ -z "$$(systemctl status networking.service | grep "Active: active ")" ]; then                        \
					echo "===== Start networking.service =====";                                                          \
					systemctl start networking.service;                                                                   \
				else                                                                                                      \
					echo "===== Restart networking.service =====";                                                        \
					systemctl restart networking.service;                                                                 \
				fi;                                                                                                       \
			else                                                                                                          \
				echo "Error: Already set $(IFACE) interface. Please remove it manually";                                  \
				exit;                                                                                                     \
			fi;                                                                                                           \
			echo "===== Done =====";                                                                                      \
			exit;                                                                                                         \
		fi;                                                                                                               \
		if [ -z "$(OS_ID)" ]; then                                                                                        \
			echo "Error: OS not supported";                                                                               \
		else                                                                                                              \
			echo "Error: $(OS_ID) OS not supported";                                                                      \
		fi;
