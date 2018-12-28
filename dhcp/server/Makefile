# Using Makefile instead of bash script

# $ make list_targets
# List all possible targets
list_targets:
	@	echo "all";
	@	echo "list_targets";

# $ sudo make all
all:
	@	if [ $$(id -u) -ne 0 ]; then                                                                            \
			echo "Error: Please run as root";                                                                   \
			exit;                                                                                               \
		fi;                                                                                                     \
		PATH_PWD=$$(pwd);                                                                                       \
		if [ ! -f $$PATH_PWD/dhcpd.conf ]; then                                                                 \
			echo "Error: File dhcpd.conf not found";                                                            \
			exit;                                                                                               \
		fi;                                                                                                     \
		if [ ! -z "$$(shasum $$PATH_PWD/dhcpd.conf | grep d054cee68719a876ca97c73fe8878ac4bb30bed0)" ]; then    \
			echo "Error: Please modify dhcpd.conf file";                                                        \
			echo "THIS IS A SAMPLE. YOU MUST EDIT IT";                                                          \
			exit;                                                                                               \
		fi;                                                                                                     \
		OS_ID=$$(cat /etc/os-release | grep "^ID=" | cut -c 4-);                                                \
		if [ "$$OS_ID" = "ubuntu" ]; then                                                                       \
			if [ -z "$$(apt list --installed | grep "^isc-dhcp-server/")" ]; then                               \
				echo "Installing isc-dhcp-server ...";                                                          \
				sudo apt-get -y install isc-dhcp-server;                                                        \
			fi;                                                                                                 \
			if [ -f /etc/dhcp/dhcpd.conf ]; then                                                                \
				sudo cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.bak;                                          \
			fi;                                                                                                 \
			sudo cp $$PATH_PWD/dhcpd.conf /etc/dhcp/dhcpd.conf;                                                 \
			if [ -z "$$(systemctl status isc-dhcp-server.service | grep -E "Active: active (running)")" ]; then \
				sudo systemctl start isc-dhcp-server.service;                                                   \
			else                                                                                                \
				sudo systemctl restart isc-dhcp-server.service;                                                 \
			fi;                                                                                                 \
			exit;                                                                                               \
		fi;                                                                                                     \
		if [ -z "$$OS_ID" ]; then                                                                               \
			echo "Error: OS not supported";                                                                     \
		else                                                                                                    \
			echo "Error: $$OS_ID OS not supported";                                                             \
		fi;

