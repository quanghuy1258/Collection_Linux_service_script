SHELL    := /bin/bash
PATH_PWD := $(shell pwd)
OS_ID    := $(shell cat /etc/os-release | grep "^ID=" | cut -c 4-)

help:
	@	echo "- Show help:                  $$ make help"
	@	echo "- Install dependencies:   (1) $$ sudo make install"
	@	echo "- Uninstall dependencies:     $$ sudo make uninstall"
	@	echo "- Configure:              (2) $$ sudo make configure CLIENT={string}"
	@	echo "- Start:                  (3) $$ sudo make start"
	@	echo "- Stop:                       $$ sudo make stop"
	@	echo "RECOMMEND: (1) -> (2) -> (3)"

install:
	@	if [ $$(id -u) -ne 0 ]; then                                      \
			echo "Error: Please run as root";                             \
			exit;                                                         \
		fi;                                                               \
		if [ "$(OS_ID)" = "ubuntu" ]; then                                \
			if [ -z "$$(apt list --installed | grep "^openvpn/")" ]; then \
				echo "===== Install openvpn =====";                       \
				apt-get -y install openvpn;                               \
			fi;                                                           \
			echo "===== Done =====";                                      \
			exit;                                                         \
		fi;                                                               \
		if [ -z "$(OS_ID)" ]; then                                        \
			echo "Error: OS not supported";                               \
		else                                                              \
			echo "Error: $(OS_ID) OS not supported";                      \
		fi;

uninstall:
	@	if [ $$(id -u) -ne 0 ]; then                                                         \
			echo "Error: Please run as root";                                                \
			exit;                                                                            \
		fi;                                                                                  \
		if [ "$(OS_ID)" = "ubuntu" ]; then                                                   \
			if [ ! -z "$$(systemctl status openvpn@client | grep "Active: active ")" ]; then \
				echo "===== Stop openvpn@client =====";                                      \
				systemctl stop openvpn@client;                                               \
			fi;                                                                              \
			if [ ! -z "$$(apt list --installed | grep "^openvpn/")" ]; then                  \
				echo "===== Uninstall openvpn =====";                                        \
				apt-get -y purge openvpn;                                                    \
			fi;                                                                              \
			echo "===== Done =====";                                                         \
			exit;                                                                            \
		fi;                                                                                  \
		if [ -z "$(OS_ID)" ]; then                                                           \
			echo "Error: OS not supported";                                                  \
		else                                                                                 \
			echo "Error: $(OS_ID) OS not supported";                                         \
		fi;

configure:
	@	if [ $$(id -u) -ne 0 ]; then                                                                           \
			echo "Error: Please run as root";                                                                  \
			exit;                                                                                              \
		fi;                                                                                                    \
		if [ ! -f "$(PATH_PWD)/ca.crt" ]; then                                                                 \
			echo "Error: File ca.crt not found";                                                               \
			exit;                                                                                              \
		fi;                                                                                                    \
		if [ -z "$(CLIENT)" ]; then                                                                            \
			echo "Error: CLIENT arg is not set";                                                               \
			exit;                                                                                              \
		fi;                                                                                                    \
		if [ ! -f "$(PATH_PWD)/$(CLIENT).crt" ]; then                                                          \
			echo "Error: File $(CLIENT).crt not found";                                                        \
			exit;                                                                                              \
		fi;                                                                                                    \
		if [ ! -f "$(PATH_PWD)/$(CLIENT).key" ]; then                                                          \
			echo "Error: File $(CLIENT).key not found";                                                        \
			exit;                                                                                              \
		fi;                                                                                                    \
		if [ ! -f "$(PATH_PWD)/ta.key" ]; then                                                                 \
			echo "Error: File ta.key not found";                                                               \
			exit;                                                                                              \
		fi;                                                                                                    \
		if [ ! -f "$(PATH_PWD)/client.conf" ]; then                                                            \
			echo "Error: File client.conf not found";                                                          \
			exit;                                                                                              \
		fi;                                                                                                    \
		if [ ! -z "$$(shasum $(PATH_PWD)/client.conf | grep 53db944849c52b1acfc56e01e35582982ed9916a)" ]; then \
			echo "Error: Please modify client.conf file";                                                      \
			echo "In client.conf: Must specify the OpenVPN server name or address";                            \
			exit;                                                                                              \
		fi;                                                                                                    \
		if [ -z "$$(cat $(PATH_PWD)/client.conf | grep "^cert $(CLIENT).crt$$")" ]; then                       \
			echo "Error: Wrong config --> $(CLIENT).crt not found";                                            \
			exit;                                                                                              \
		fi;                                                                                                    \
		if [ -z "$$(cat $(PATH_PWD)/client.conf | grep "^key $(CLIENT).key$$")" ]; then                        \
			echo "Error: Wrong config --> $(CLIENT).key not found";                                            \
			exit;                                                                                              \
		fi;                                                                                                    \
		if [ "$(OS_ID)" = "ubuntu" ]; then                                                                     \
			mkdir -p /etc/openvpn/;                                                                            \
			cp $(PATH_PWD)/client.conf /etc/openvpn/;                                                          \
			cp $(PATH_PWD)/ca.crt /etc/openvpn/;                                                               \
			cp $(PATH_PWD)/$(CLIENT).crt /etc/openvpn/;                                                        \
			cp $(PATH_PWD)/$(CLIENT).key /etc/openvpn/;                                                        \
			cp $(PATH_PWD)/ta.key /etc/openvpn/;                                                               \
			echo "===== Done =====";                                                                           \
			exit;                                                                                              \
		fi;                                                                                                    \
		if [ -z "$(OS_ID)" ]; then                                                                             \
			echo "Error: OS not supported";                                                                    \
		else                                                                                                   \
			echo "Error: $(OS_ID) OS not supported";                                                           \
		fi;

start:
	@	if [ $$(id -u) -ne 0 ]; then                                                       \
			echo "Error: Please run as root";                                              \
			exit;                                                                          \
		fi;                                                                                \
		if [ "$(OS_ID)" = "ubuntu" ]; then                                                 \
			if [ -z "$$(systemctl status openvpn@client | grep "Active: active ")" ]; then \
				echo "===== Start openvpn@client =====";                                   \
				systemctl start openvpn@client;                                            \
			else                                                                           \
				echo "===== Restart openvpn@client =====";                                 \
				systemctl restart openvpn@client;                                          \
			fi;                                                                            \
			echo "===== Done =====";                                                       \
			exit;                                                                          \
		fi;                                                                                \
		if [ -z "$(OS_ID)" ]; then                                                         \
			echo "Error: OS not supported";                                                \
		else                                                                               \
			echo "Error: $(OS_ID) OS not supported";                                       \
		fi;

stop:
	@	if [ $$(id -u) -ne 0 ]; then                                                         \
			echo "Error: Please run as root";                                                \
			exit;                                                                            \
		fi;                                                                                  \
		if [ "$(OS_ID)" = "ubuntu" ]; then                                                   \
			if [ ! -z "$$(systemctl status openvpn@client | grep "Active: active ")" ]; then \
				echo "===== Stop openvpn@client =====";                                      \
				systemctl stop openvpn@client;                                               \
			fi;                                                                              \
			echo "===== Done =====";                                                         \
			exit;                                                                            \
		fi;                                                                                  \
		if [ -z "$(OS_ID)" ]; then                                                           \
			echo "Error: OS not supported";                                                  \
		else                                                                                 \
			echo "Error: $(OS_ID) OS not supported";                                         \
		fi;
