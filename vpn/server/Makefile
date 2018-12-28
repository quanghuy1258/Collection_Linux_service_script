# Using Makefile instead of bash script

# $ make list_targets
# List all possible targets
list_targets:
	@	echo "all";
	@	echo "client CLIENT={string}";
	@	echo "list_targets";

# $ sudo make all
all:
	@	if [ $$(id -u) -ne 0 ]; then                                                                      \
			echo "Error: Please run as root";                                                             \
			exit;                                                                                         \
		fi;                                                                                               \
		PATH_VARS=$$(pwd)/vars;                                                                           \
		if [ ! -f $$PATH_VARS ]; then                                                                     \
			echo "Error: File vars not found";                                                            \
			exit;                                                                                         \
		fi;                                                                                               \
		if [ ! -z "$$(shasum $$PATH_VARS | grep 2f97e05577b3b2a4f6e163a3fd503ec94d6e3ef1)" ]; then        \
			echo "Warning: Please modify vars file";                                                      \
			read -r -p "Continue? [y/N] " response;                                                       \
			if [ -z "$$(echo $$response | grep -E "^([yY][eE][sS]|y)$$")" ]; then                         \
				exit;                                                                                     \
			fi;                                                                                           \
		fi;                                                                                               \
		PATH_SERVER_CONF=$$(pwd)/server.conf;                                                             \
		if [ ! -f $$PATH_SERVER_CONF ]; then                                                              \
			echo "Error: File server.conf not found";                                                     \
			exit;                                                                                         \
		fi;                                                                                               \
		if [ ! -z "$$(shasum $$PATH_SERVER_CONF | grep 4e3b1ee2dbe2ab5272c4afdb829db67accc027d3)" ]; then \
			echo "Warning: Please modify server.conf file";                                               \
			read -r -p "Continue? [y/N] " response;                                                       \
			if [ -z "$$(echo $$response | grep -E "^([yY][eE][sS]|y)$$")" ]; then                         \
				exit;                                                                                     \
			fi;                                                                                           \
		fi;                                                                                               \
		OS_ID=$$(cat /etc/os-release | grep "^ID=" | cut -c 4-);                                          \
		if [ "$$OS_ID" = "ubuntu" ]; then                                                                 \
			if [ -z "$$(apt list --installed | grep "^openvpn/")" ]; then                                 \
				echo "Installing openvpn ...";                                                            \
				sudo apt-get -y install openvpn;                                                          \
			fi;                                                                                           \
			if [ -z "$$(apt list --installed | grep "^easy-rsa/")" ]; then                                \
				echo "Installing easy-rsa ...";                                                           \
				sudo apt-get -y install easy-rsa;                                                         \
			fi;                                                                                           \
			sudo mkdir -p /etc/openvpn/easy-rsa/;                                                         \
			sudo cp -r /usr/share/easy-rsa/* /etc/openvpn/easy-rsa/;                                      \
			sudo cp $$PATH_VARS /etc/openvpn/easy-rsa/;                                                   \
			sudo cp $$PATH_SERVER_CONF /etc/openvpn/;                                                     \
			PATH_PWD=$$(pwd);                                                                             \
			cd /etc/openvpn/easy-rsa/;                                                                    \
			source vars;                                                                                  \
			sudo ./clean-all;                                                                             \
			sudo ./build-ca;                                                                              \
			sudo ./build-key-server server;                                                               \
			sudo ./build-dh;                                                                              \
			cd keys/;                                                                                     \
			sudo cp server.crt server.key ca.crt dh2048.pem /etc/openvpn/;                                \
			cd /etc/openvpn;                                                                              \
			sudo openvpn --genkey --secret ta.key;                                                        \
			if [ -z "$$(systemctl status openvpn@server | grep -E "Active: active (running)")" ]; then    \
				sudo systemctl start openvpn@server;                                                      \
			else                                                                                          \
				sudo systemctl restart openvpn@server;                                                    \
			fi;                                                                                           \
			cd $$PATH_PWD;                                                                                \
			exit;                                                                                         \
		fi;                                                                                               \
		if [ -z "$$OS_ID" ]; then                                                                         \
			echo "Error: OS not supported";                                                               \
		else                                                                                              \
			echo "Error: $$OS_ID OS not supported";                                                       \
		fi;

# $ sudo make client CLIENT={string}
# Create a client
client:
	@	if [ $$(id -u) -ne 0 ]; then                                                    \
			echo "Error: Please run as root";                                           \
			exit;                                                                       \
		fi;                                                                             \
		if [ -z $(CLIENT) ]; then                                                       \
			echo "Error: CLIENT arg is not set";                                        \
			exit;                                                                       \
		fi;                                                                             \
		PATH_PWD=$$(pwd);                                                               \
		cd /etc/openvpn/easy-rsa/ || (echo "Error: Please run make all first" && exit); \
		if [ -z "$$(ls | grep vars)" ]; then                                            \
			echo "Error: Please run make all first";                                    \
			exit;                                                                       \
		else                                                                            \
			source vars;                                                                \
		fi;                                                                             \
		sudo ./build-key $(CLIENT);                                                     \
		cp /etc/openvpn/ca.crt $$PATH_PWD;                                              \
		cp /etc/openvpn/easy-rsa/keys/$(CLIENT).crt $$PATH_PWD;                         \
		cp /etc/openvpn/easy-rsa/keys/$(CLIENT).key $$PATH_PWD;                         \
		cp /et/openvpn/ta.key $$PATH_PWD;                                               \
		cd $$PATH_PWD;

