# Using Makefile instead of bash script

SHELL := /bin/bash

# $ make list_targets
# List all possible targets
list_targets:
	@	echo "all CLIENT={string}";
	@	echo "list_targets";

# $ sudo make all CLIENT={string}
all:
	@	if [ $$(id -u) -ne 0 ]; then                                                                      \
			echo "Error: Please run as root";                                                             \
			exit;                                                                                         \
		fi;                                                                                               \
		PATH_PWD=$$(pwd);                                                                                 \
		if [ ! -f $$PATH_PWD/ca.crt ]; then                                                               \
			echo "Error: File ca.crt not found";                                                          \
			exit;                                                                                         \
		fi;                                                                                               \
		if [ -z $(CLIENT) ]; then                                                                         \
			echo "Error: CLIENT arg is not set";                                                          \
			exit;                                                                                         \
		fi;                                                                                               \
		if [ ! -f $$PATH_PWD/$(CLIENT).crt ]; then                                                        \
			echo "Error: File $(CLIENT).crt not found";                                                   \
			exit;                                                                                         \
		fi;                                                                                               \
		if [ ! -f $$PATH_PWD/$(CLIENT).key ]; then                                                        \
			echo "Error: File $(CLIENT).key not found";                                                   \
			exit;                                                                                         \
		fi;                                                                                               \
		if [ ! -f $$PATH_PWD/ta.key ]; then                                                               \
			echo "Error: File ta.key not found";                                                          \
			exit;                                                                                         \
		fi;                                                                                               \
		PATH_CLIENT_CONF=$$(pwd)/client.conf;                                                             \
		if [ ! -f $$PATH_CLIENT_CONF ]; then                                                              \
			echo "Error: File client.conf not found";                                                     \
			exit;                                                                                         \
		fi;                                                                                               \
		if [ ! -z "$$(shasum $$PATH_CLIENT_CONF | grep 5534b3f1e5630fa48f3d3c8360d1130658766cd9)" ]; then \
			echo "Error: Please modify client.conf file";                                                 \
			echo "In client.conf: Must specify the OpenVPN server name or address";                       \
			exit;                                                                                         \
		fi;                                                                                               \
		if [ -z "$$(cat $$PATH_CLIENT_CONF | grep "^cert $(CLIENT).crt$$")" ]; then                       \
			echo "Error: Wrong config --> $(CLIENT).crt not found";                                       \
			exit;                                                                                         \
		fi;                                                                                               \
		if [ -z "$$(cat $$PATH_CLIENT_CONF | grep "^key $(CLIENT).key$$")" ]; then                        \
			echo "Error: Wrong config --> $(CLIENT).key not found";                                       \
			exit;                                                                                         \
		fi;                                                                                               \
		OS_ID=$$(cat /etc/os-release | grep "^ID=" | cut -c 4-);                                          \
		if [ "$$OS_ID" = "ubuntu" ]; then                                                                 \
			if [ -z "$$(apt list --installed | grep "^openvpn/")" ]; then                                 \
				echo "Installing openvpn ...";                                                            \
				sudo apt-get -y install openvpn;                                                          \
			fi;                                                                                           \
			sudo mkdir -p /etc/openvpn/;                                                                  \
			sudo cp $$PATH_CLIENT_CONF /etc/openvpn/;                                                     \
			sudo cp $$PATH_PWD/ca.crt /etc/openvpn/;                                                      \
			sudo cp $$PATH_PWD/$(CLIENT).crt /etc/openvpn/;                                               \
			sudo cp $$PATH_PWD/$(CLIENT).key /etc/openvpn/;                                               \
			sudo cp $$PATH_PWD/ta.key /etc/openvpn/;                                                      \
			if [ -z "$$(systemctl status openvpn@client | grep -E "Active: active (running)")" ]; then    \
				sudo systemctl start openvpn@client;                                                      \
			else                                                                                          \
				sudo systemctl restart openvpn@client;                                                    \
			fi;                                                                                           \
			exit;                                                                                         \
		fi;                                                                                               \
		if [ -z "$$OS_ID" ]; then                                                                         \
			echo "Error: OS not supported";                                                               \
		else                                                                                              \
			echo "Error: $$OS_ID OS not supported";                                                       \
		fi;

