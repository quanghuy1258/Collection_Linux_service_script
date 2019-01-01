SHELL    := /bin/bash
PATH_PWD := $(shell pwd)

help:
	@	echo "- Show help:                  $$ make help"
	@	echo "- Install dependencies:   (1) $$ sudo make install"
	@	echo "- Uninstall dependencies:     $$ sudo make uninstall"
	@	echo "- Init configure:         (2) $$ sudo make init"
	@	echo "- Config server:          (3) $$ sudo make server"
	@	echo "- Start service:          (4) $$ sudo make start"
	@	echo "- Create client cert:         $$ sudo make client CLIENT={string}"
	@	echo "RECOMMEND: (1) -> (2) -> (3) -> (4)"

install:
	@	if [ $$(id -u) -ne 0 ]; then                                       \
			echo "Error: Please run as root";                              \
			exit;                                                          \
		fi;                                                                \
		OS_ID=$$(cat /etc/os-release | grep "^ID=" | cut -c 4-);           \
		if [ "$$OS_ID" = "ubuntu" ]; then                                  \
			if [ -z "$$(apt list --installed | grep "^openvpn/")" ]; then  \
				echo "===== Install openvpn =====";                        \
				apt-get -y install openvpn;                                \
			fi;                                                            \
			if [ -z "$$(apt list --installed | grep "^easy-rsa/")" ]; then \
				echo "===== Install easy-rsa =====";                       \
				apt-get -y install easy-rsa;                               \
			fi;                                                            \
			echo "===== Done =====";                                       \
			exit;                                                          \
		fi;                                                                \
		if [ -z "$$OS_ID" ]; then                                          \
			echo "Error: OS not supported";                                \
		else                                                               \
			echo "Error: $$OS_ID OS not supported";                        \
		fi;

uninstall:
	@	if [ $$(id -u) -ne 0 ]; then                                                                     \
			echo "Error: Please run as root";                                                            \
			exit;                                                                                        \
		fi;                                                                                              \
		OS_ID=$$(cat /etc/os-release | grep "^ID=" | cut -c 4-);                                         \
		if [ "$$OS_ID" = "ubuntu" ]; then                                                                \
			if [ ! -z "$$(systemctl status openvpn@server | grep -E "Active: active (running)")" ]; then \
				systemctl stop openvpn@server;                                                           \
			fi;                                                                                          \
			rm -rf /etc/openvpn/easy-rsa/;                                                               \
			if [ ! -z "$$(apt list --installed | grep "^openvpn/")" ]; then                              \
				echo "===== Uninstall openvpn =====";                                                    \
				apt-get -y purge openvpn;                                                                \
			fi;                                                                                          \
			if [ ! -z "$$(apt list --installed | grep "^easy-rsa/")" ]; then                             \
				echo "===== Uninstall easy-rsa =====";                                                   \
				apt-get -y purge easy-rsa;                                                               \
			fi;                                                                                          \
			echo "===== Done =====";                                                                     \
			exit;                                                                                        \
		fi;                                                                                              \
		if [ -z "$$OS_ID" ]; then                                                                        \
			echo "Error: OS not supported";                                                              \
		else                                                                                             \
			echo "Error: $$OS_ID OS not supported";                                                      \
		fi;

init:
	@	if [ $$(id -u) -ne 0 ]; then                                                                    \
			echo "Error: Please run as root";                                                           \
			exit;                                                                                       \
		fi;                                                                                             \
		if [ ! -z "$$(shasum $(PATH_PWD)/vars | grep 3405c1b017af5aecd7e6bde344cdd8713909314f)" ]; then \
			echo "Warning: Please modify vars file";                                                    \
			read -r -p "Continue? [y/N] " response;                                                     \
			if [ -z "$$(echo $$response | grep -E "^([yY][eE][sS]|y)$$")" ]; then                       \
				exit;                                                                                   \
			fi;                                                                                         \
		fi;                                                                                             \
		OS_ID=$$(cat /etc/os-release | grep "^ID=" | cut -c 4-);                                        \
		if [ "$$OS_ID" = "ubuntu" ]; then                                                               \
			mkdir -p /etc/openvpn/easy-rsa/keys;                                                        \
			cp -r /usr/share/easy-rsa/* /etc/openvpn/easy-rsa/;                                         \
			cp $(PATH_PWD)/vars /etc/openvpn/easy-rsa/;                                                 \
			cd /etc/openvpn/easy-rsa/;                                                                  \
			source ./vars;                                                                              \
			./clean-all;                                                                                \
			echo "===== Init CA =====";                                                                 \
			./build-ca;                                                                                 \
			echo "===== Build DH =====";                                                                \
			./build-dh;                                                                                 \
			cd keys/;                                                                                   \
			cp ca.crt dh*.pem /etc/openvpn/;                                                            \
			cd /etc/openvpn;                                                                            \
			echo "===== Build ta.key =====";                                                            \
			openvpn --genkey --secret ta.key;                                                           \
			cd $(PATH_PWD);                                                                             \
			echo "===== Done =====";                                                                    \
			exit;                                                                                       \
		fi;                                                                                             \
		if [ -z "$$OS_ID" ]; then                                                                       \
			echo "Error: OS not supported";                                                             \
		else                                                                                            \
			echo "Error: $$OS_ID OS not supported";                                                     \
		fi;

server:
	@	if [ $$(id -u) -ne 0 ]; then                                                                           \
			echo "Error: Please run as root";                                                                  \
			exit;                                                                                              \
		fi;                                                                                                    \
		if [ ! -z "$$(shasum $(PATH_PWD)/server.conf | grep da02fc70086b6c87da514f33ef7990035cf58c5f)" ]; then \
			echo "Warning: Please modify server.conf file";                                                    \
			read -r -p "Continue? [y/N] " response;                                                            \
			if [ -z "$$(echo $$response | grep -E "^([yY][eE][sS]|y)$$")" ]; then                              \
				exit;                                                                                          \
			fi;                                                                                                \
		fi;                                                                                                    \
		OS_ID=$$(cat /etc/os-release | grep "^ID=" | cut -c 4-);                                               \
		if [ "$$OS_ID" = "ubuntu" ]; then                                                                      \
			cp $(PATH_PWD)/server.conf /etc/openvpn/;                                                          \
			cd /etc/openvpn/easy-rsa/;                                                                         \
			source ./vars;                                                                                     \
			echo "===== Build server key: server =====";                                                       \
			./build-key-server server;                                                                         \
			cd keys/;                                                                                          \
			cp server.crt server.key /etc/openvpn/;                                                            \
			cd $(PATH_PWD);                                                                                    \
			echo "===== Done =====";                                                                           \
			exit;                                                                                              \
		fi;                                                                                                    \
		if [ -z "$$OS_ID" ]; then                                                                              \
			echo "Error: OS not supported";                                                                    \
		else                                                                                                   \
			echo "Error: $$OS_ID OS not supported";                                                            \
		fi;

start:
	@	if [ $$(id -u) -ne 0 ]; then                                                                   \
			echo "Error: Please run as root";                                                          \
			exit;                                                                                      \
		fi;                                                                                            \
		OS_ID=$$(cat /etc/os-release | grep "^ID=" | cut -c 4-);                                       \
		if [ "$$OS_ID" = "ubuntu" ]; then                                                              \
			if [ -z "$$(systemctl status openvpn@server | grep -E "Active: active (running)")" ]; then \
				systemctl start openvpn@server;                                                        \
			else                                                                                       \
				systemctl restart openvpn@server;                                                      \
			fi;                                                                                        \
			echo "===== Done =====";                                                                   \
			exit;                                                                                      \
		fi;                                                                                            \
		if [ -z "$$OS_ID" ]; then                                                                      \
			echo "Error: OS not supported";                                                            \
		else                                                                                           \
			echo "Error: $$OS_ID OS not supported";                                                    \
		fi;

client:
	@	if [ $$(id -u) -ne 0 ]; then                                 \
			echo "Error: Please run as root";                        \
			exit;                                                    \
		fi;                                                          \
		if [ -z $(CLIENT) ]; then                                    \
			echo "Error: CLIENT arg is not set";                     \
			exit;                                                    \
		fi;                                                          \
		OS_ID=$$(cat /etc/os-release | grep "^ID=" | cut -c 4-);     \
		if [ "$$OS_ID" = "ubuntu" ]; then                            \
			cd /etc/openvpn/easy-rsa/;                               \
			source vars;                                             \
			./build-key $(CLIENT);                                   \
			cd $(PATH_PWD);                                          \
			cp /etc/openvpn/easy-rsa/keys/ca.crt $(PATH_PWD);        \
			cp /etc/openvpn/easy-rsa/keys/$(CLIENT).crt $(PATH_PWD); \
			cp /etc/openvpn/easy-rsa/keys/$(CLIENT).key $(PATH_PWD); \
			cp /etc/openvpn/ta.key $(PATH_PWD);                      \
			chmod a+rw ca.crt $(CLIENT).crt $(CLIENT).key ta.key;    \
			echo "===== Done =====";                                 \
			exit;                                                    \
		fi;                                                          \
		if [ -z "$$OS_ID" ]; then                                    \
			echo "Error: OS not supported";                          \
		else                                                         \
			echo "Error: $$OS_ID OS not supported";                  \
		fi;

