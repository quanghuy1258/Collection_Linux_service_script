SHELL    := /bin/bash
PATH_PWD := $(shell pwd)
OS_ID    := $(shell cat /etc/os-release | grep "^ID=" | cut -c 4-)

help:
	@	echo "- Show help:                             $$ make help"
	@	echo "- Install dependencies:              (1) $$ sudo make install"
	@	echo "- Remove TAP:                            $$ sudo make remove_tap BR=br0 TAP=\"tap0 tap1\""
	@	echo "- Uninstall dependencies:                $$ sudo make uninstall"
	@	echo "- Init configure:                    (2) $$ sudo make init"
	@	echo "- Create server cert & key:          (3) $$ sudo make server"
	@	echo "- Configure routing & firewall:      (4) $$ sudo make routing_firewall"
	@	echo "- Add TAP:                               $$ sudo make add_tap BR=br0 TAP=\"tap0 tap1\" ETH=eth0 ETH_IP=192.168.8.4 ETH_NETMASK=255.255.255.0 ETH_BROADCAST=192.168.8.255"
	@	echo "- Add server config & start service: (5) $$ sudo make start"
	@	echo "- Create client cert & key:              $$ sudo make client CLIENT={string}"
	@	echo "RECOMMEND: (1) -> (2) -> (3) -> (4) -> (5)"

install:
	@	if [ $$(id -u) -ne 0 ]; then                                           \
			echo "Error: Please run as root";                                  \
			exit;                                                              \
		fi;                                                                    \
		if [ "$(OS_ID)" = "ubuntu" ]; then                                     \
			if [ -z "$$(apt list --installed | grep "^openvpn/")" ]; then      \
				echo "===== Install openvpn =====";                            \
				apt-get -y install openvpn;                                    \
			fi;                                                                \
			if [ -z "$$(apt list --installed | grep "^easy-rsa/")" ]; then     \
				echo "===== Install easy-rsa =====";                           \
				apt-get -y install easy-rsa;                                   \
			fi;                                                                \
			if [ -z "$$(apt list --installed | grep "^bridge-utils/")" ]; then \
				echo "===== Install bridge-utils =====";                       \
				apt-get -y install bridge-utils;                               \
			fi;                                                                \
			echo "===== Done =====";                                           \
			exit;                                                              \
		fi;                                                                    \
		if [ -z "$(OS_ID)" ]; then                                             \
			echo "Error: OS not supported";                                    \
		else                                                                   \
			echo "Error: $(OS_ID) OS not supported";                           \
		fi;

remove_tap:
	@	if [ $$(id -u) -ne 0 ]; then                                          \
			echo "Error: Please run as root";                                 \
			exit;                                                             \
		fi;                                                                   \
		if [ -z "$(BR)" ]; then                                               \
			echo "Error: BR arg is not set";                                  \
			exit;                                                             \
		fi;                                                                   \
		if [ -z "$(TAP)" ]; then                                              \
			echo "Error: TAP arg is not set";                                 \
			exit;                                                             \
		fi;                                                                   \
		if [ ! -f "$(PATH_PWD)/bridge-stop.bak" ]; then                       \
			if [ ! -f "$(PATH_PWD)/bridge-stop" ]; then                       \
				echo "Error: File bridge-stop not found";                     \
				exit;                                                         \
			fi;                                                               \
			cp $(PATH_PWD)/bridge-stop $(PATH_PWD)/bridge-stop.bak;           \
		fi;                                                                   \
		cat $(PATH_PWD)/bridge-stop.bak >$(PATH_PWD)/bridge-stop;             \
		echo "Check your args: BR=$(BR), TAP=$(TAP)";                         \
		echo "Warning: Example -> BR=br0 TAP=\"tap0 tap1\"";                  \
		read -r -p "Continue? [y/N] " response;                               \
		if [ -z "$$(echo $$response | grep -E "^([yY][eE][sS]|y)$$")" ]; then \
			exit;                                                             \
		fi;                                                                   \
		if [ "$(OS_ID)" = "ubuntu" ]; then                                    \
			sed -re "s/br0/$(BR)/g" -i $(PATH_PWD)/bridge-stop;               \
			sed -re "s/tap0/$(TAP)/g" -i $(PATH_PWD)/bridge-stop;             \
			$(PATH_PWD)/bridge-stop;                                          \
			echo "===== Done =====";                                          \
			exit;                                                             \
		fi;                                                                   \
		if [ -z "$(OS_ID)" ]; then                                            \
			echo "Error: OS not supported";                                   \
		else                                                                  \
			echo "Error: $(OS_ID) OS not supported";                          \
		fi;

uninstall:
	@	if [ $$(id -u) -ne 0 ]; then                                                         \
			echo "Error: Please run as root";                                                \
			exit;                                                                            \
		fi;                                                                                  \
		if [ "$(OS_ID)" = "ubuntu" ]; then                                                   \
			if [ ! -z "$$(systemctl status openvpn@server | grep "Active: active ")" ]; then \
				echo "===== Stop openvpn@server =====";                                      \
				systemctl stop openvpn@server;                                               \
			fi;                                                                              \
			rm -rf /etc/openvpn/easy-rsa/;                                                   \
			if [ ! -z "$$(apt list --installed | grep "^openvpn/")" ]; then                  \
				echo "===== Uninstall openvpn =====";                                        \
				apt-get -y purge openvpn;                                                    \
			fi;                                                                              \
			if [ ! -z "$$(apt list --installed | grep "^easy-rsa/")" ]; then                 \
				echo "===== Uninstall easy-rsa =====";                                       \
				apt-get -y purge easy-rsa;                                                   \
			fi;                                                                              \
			echo "===== Done =====";                                                         \
			exit;                                                                            \
		fi;                                                                                  \
		if [ -z "$(OS_ID)" ]; then                                                           \
			echo "Error: OS not supported";                                                  \
		else                                                                                 \
			echo "Error: $(OS_ID) OS not supported";                                         \
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
		if [ "$(OS_ID)" = "ubuntu" ]; then                                                              \
			mkdir -p /etc/openvpn/easy-rsa/keys;                                                        \
			cp -r /usr/share/easy-rsa/* /etc/openvpn/easy-rsa/;                                         \
			cp $(PATH_PWD)/vars /etc/openvpn/easy-rsa/;                                                 \
			cd /etc/openvpn/easy-rsa/;                                                                  \
			ln -s openssl-1.0.0.cnf openssl.cnf;                                                        \
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
		if [ -z "$(OS_ID)" ]; then                                                                      \
			echo "Error: OS not supported";                                                             \
		else                                                                                            \
			echo "Error: $(OS_ID) OS not supported";                                                    \
		fi;

server:
	@	if [ $$(id -u) -ne 0 ]; then                     \
			echo "Error: Please run as root";            \
			exit;                                        \
		fi;                                              \
		if [ "$(OS_ID)" = "ubuntu" ]; then               \
			cd /etc/openvpn/easy-rsa/;                   \
			source ./vars;                               \
			echo "===== Build server key: server ====="; \
			./build-key-server server;                   \
			cd keys/;                                    \
			cp server.crt server.key /etc/openvpn/;      \
			cd $(PATH_PWD);                              \
			echo "===== Done =====";                     \
			exit;                                        \
		fi;                                              \
		if [ -z "$(OS_ID)" ]; then                       \
			echo "Error: OS not supported";              \
		else                                             \
			echo "Error: $(OS_ID) OS not supported";     \
		fi;

routing_firewall:
	@	if [ $$(id -u) -ne 0 ]; then                                                                           \
			echo "Error: Please run as root";                                                                  \
			exit;                                                                                              \
		fi;                                                                                                    \
		if [ ! -f "$(PATH_PWD)/routing.sh" ]; then                                                             \
			echo "Error: File routing.sh not found";                                                           \
			exit;                                                                                              \
		fi;                                                                                                    \
		if [ ! -z "$$(shasum $(PATH_PWD)/routing.sh | grep 14ff6c74f507499538488afd80f6b7092d601b7d)" ]; then  \
			echo "Warning: Please modify routing.sh file";                                                     \
			read -r -p "Continue? [y/N] " response;                                                            \
			if [ -z "$$(echo $$response | grep -E "^([yY][eE][sS]|y)$$")" ]; then                              \
				exit;                                                                                          \
			fi;                                                                                                \
		fi;                                                                                                    \
		if [ ! -f "$(PATH_PWD)/firewall.sh" ]; then                                                            \
			echo "Error: File firewall.sh not found";                                                          \
			exit;                                                                                              \
		fi;                                                                                                    \
		if [ ! -z "$$(shasum $(PATH_PWD)/firewall.sh | grep 69d4688817c70dc56dab3b6656aa44d34f574c7a)" ]; then \
			echo "Error: Please modify firewall.sh file";                                                      \
			exit;                                                                                              \
		fi;                                                                                                    \
		if [ "$(OS_ID)" = "ubuntu" ]; then                                                                     \
			$(PATH_PWD)/routing.sh;                                                                            \
			$(PATH_PWD)/firewall.sh;                                                                           \
			echo "===== Done =====";                                                                           \
			exit;                                                                                              \
		fi;                                                                                                    \
		if [ -z "$(OS_ID)" ]; then                                                                             \
			echo "Error: OS not supported";                                                                    \
		else                                                                                                   \
			echo "Error: $(OS_ID) OS not supported";                                                           \
		fi;

add_tap:
	@	if [ $$(id -u) -ne 0 ]; then                                                                                                         \
			echo "Error: Please run as root";                                                                                                \
			exit;                                                                                                                            \
		fi;                                                                                                                                  \
		if [ -z "$(BR)" ]; then                                                                                                              \
			echo "Error: BR arg is not set";                                                                                                 \
			exit;                                                                                                                            \
		fi;                                                                                                                                  \
		if [ -z "$(TAP)" ]; then                                                                                                             \
			echo "Error: TAP arg is not set";                                                                                                \
			exit;                                                                                                                            \
		fi;                                                                                                                                  \
		if [ -z "$(ETH)" ]; then                                                                                                             \
			echo "Error: ETH arg is not set";                                                                                                \
			exit;                                                                                                                            \
		fi;                                                                                                                                  \
		if [ -z "$(ETH_IP)" ]; then                                                                                                          \
			echo "Error: ETH_IP arg is not set";                                                                                             \
			exit;                                                                                                                            \
		fi;                                                                                                                                  \
		if [ -z "$(ETH_NETMASK)" ]; then                                                                                                     \
			echo "Error: ETH_NETMASK arg is not set";                                                                                        \
			exit;                                                                                                                            \
		fi;                                                                                                                                  \
		if [ -z "$(ETH_BROADCAST)" ]; then                                                                                                   \
			echo "Error: ETH_BROADCAST arg is not set";                                                                                      \
			exit;                                                                                                                            \
		fi;                                                                                                                                  \
		if [ ! -f "$(PATH_PWD)/bridge-start.bak" ]; then                                                                                     \
			if [ ! "-f $(PATH_PWD)/bridge-start" ]; then                                                                                     \
				echo "Error: File bridge-start not found";                                                                                   \
				exit;                                                                                                                        \
			fi;                                                                                                                              \
			cp $(PATH_PWD)/bridge-start $(PATH_PWD)/bridge-start.bak;                                                                        \
		fi;                                                                                                                                  \
		cat $(PATH_PWD)/bridge-start.bak >$(PATH_PWD)/bridge-start;                                                                          \
		echo "Check your args: BR=$(BR), TAP=$(TAP) ETH=$(ETH) ETH_IP=$(ETH_IP) ETH_NETMASK=$(ETH_NETMASK) ETH_BROADCAST=$(ETH_BROADCAST)";  \
		echo "Warning: Example -> BR=br0 TAP="tap0 tap1" ETH=eth0 ETH_IP=192.168.8.4 ETH_NETMASK=255.255.255.0 ETH_BROADCAST=192.168.8.255"; \
		read -r -p "Continue? [y/N] " response;                                                                                              \
		if [ -z "$$(echo $$response | grep -E "^([yY][eE][sS]|y)$$")" ]; then                                                                \
			exit;                                                                                                                            \
		fi;                                                                                                                                  \
		if [ "$(OS_ID)" = "ubuntu" ]; then                                                                                                   \
			sed -re "s/br0/$(BR)/g" -i $(PATH_PWD)/bridge-start;                                                                             \
			sed -re "s/tap0/$(TAP)/g" -i $(PATH_PWD)/bridge-start;                                                                           \
			sed -re "s/eth0/$(ETH)/g" -i $(PATH_PWD)/bridge-start;                                                                           \
			sed -re "s/192.168.8.4/$(ETH_IP)/g" -i $(PATH_PWD)/bridge-start;                                                                 \
			sed -re "s/255.255.255.0/$(ETH_NETMASK)/g" -i $(PATH_PWD)/bridge-start;                                                          \
			sed -re "s/192.168.8.255/$(ETH_BROADCAST)/g" -i $(PATH_PWD)/bridge-start;                                                        \
			$(PATH_PWD)/bridge-start;                                                                                                        \
			echo "===== Done =====";                                                                                                         \
			exit;                                                                                                                            \
		fi;                                                                                                                                  \
		if [ -z "$(OS_ID)" ]; then                                                                                                           \
			echo "Error: OS not supported";                                                                                                  \
		else                                                                                                                                 \
			echo "Error: $(OS_ID) OS not supported";                                                                                         \
		fi;

start:
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
		if [ ! -z "$$(cat $(PATH_PWD)/server.conf | grep -E "^dev tap")" ]; then                               \
			if [ -z "$$(cat $(PATH_PWD)/server.conf | grep -E "^server-bridge nogw")" ]; then                  \
				echo "REMEMBER:";                                                                              \
				echo "server-bridge gateway netmask pool-start-IP pool-end-IP = {";                            \
				echo "    mode server";                                                                        \
				echo "    tls-server";                                                                         \
				echo "    ifconfig-pool pool-start-IP pool-end-IP netmask";                                    \
				echo "    push \"route-gateway gateway\"";                                                     \
				echo "}";                                                                                      \
				echo "server-bridge = {";                                                                      \
				echo "    mode server";                                                                        \
				echo "    tls-server";                                                                         \
				echo "    push \"route-gateway dhcp\""   ;                                                     \
				echo "}";                                                                                      \
				echo "server-bridge nogw = {";                                                                 \
				echo "    mode server";                                                                        \
				echo "    tls-server";                                                                         \
				echo "}";                                                                                      \
				echo "TIP: If having problem with server-bridge mode, try server-bridge nogw";                 \
				read -r -p "Continue? [y/N] " response;                                                        \
				if [ -z "$$(echo $$response | grep -E "^([yY][eE][sS]|y)$$")" ]; then                          \
					exit;                                                                                      \
				fi;                                                                                            \
			fi;                                                                                                \
		fi;                                                                                                    \
		if [ "$(OS_ID)" = "ubuntu" ]; then                                                                     \
			cp $(PATH_PWD)/server.conf /etc/openvpn/;                                                          \
			if [ -z "$$(systemctl status openvpn@server | grep "Active: active ")" ]; then                     \
				echo "===== Start openvpn@server =====";                                                       \
				systemctl start openvpn@server;                                                                \
			else                                                                                               \
				echo "===== Restart openvpn@server =====";                                                     \
				systemctl restart openvpn@server;                                                              \
			fi;                                                                                                \
			echo "===== Done =====";                                                                           \
			exit;                                                                                              \
		fi;                                                                                                    \
		if [ -z "$(OS_ID)" ]; then                                                                             \
			echo "Error: OS not supported";                                                                    \
		else                                                                                                   \
			echo "Error: $(OS_ID) OS not supported";                                                           \
		fi;

client:
	@	if [ $$(id -u) -ne 0 ]; then                                 \
			echo "Error: Please run as root";                        \
			exit;                                                    \
		fi;                                                          \
		if [ -z "$(CLIENT)" ]; then                                  \
			echo "Error: CLIENT arg is not set";                     \
			exit;                                                    \
		fi;                                                          \
		if [ "$(OS_ID)" = "ubuntu" ]; then                           \
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
		if [ -z "$(OS_ID)" ]; then                                   \
			echo "Error: OS not supported";                          \
		else                                                         \
			echo "Error: $(OS_ID) OS not supported";                 \
		fi;

