# Using Makefile instead of bash script

# $ make list_targets
# List all possible targets
list_targets:
	@	echo "all";
	@	echo "list_targets";

# $ sudo make all
all:
	@	if [ $$(id -u) -ne 0 ]; then                                                                      \
			echo "Error: Please run as root";                                                             \
			exit;                                                                                         \
		fi;                                                                                               \
		PATH_SSHD_CONFIG=$$(pwd)/sshd_config;                                                             \
		if [ ! -f $$PATH_SSHD_CONFIG ]; then                                                              \
			echo "Error: File sshd_config not found";                                                     \
			exit;                                                                                         \
		fi;                                                                                               \
		if [ ! -z "$$(shasum $$PATH_SSHD_CONFIG | grep 884d841989244fe2331a126cf392e6c6036008f3)" ]; then \
			echo "Warning: Please modify sshd_config file";                                               \
			read -r -p "Continue? [y/N] " response;                                                       \
			if [ -z "$$(echo $$response | grep -E "^([yY][eE][sS]|y)$$")" ]; then                         \
				exit;                                                                                     \
			fi;                                                                                           \
		fi;                                                                                               \
		OS_ID=$$(cat /etc/os-release | grep "^ID=" | cut -c 4-);                                          \
		if [ "$$OS_ID" = "ubuntu" ]; then                                                                 \
			if [ -z "$$(apt list --installed | grep openssh-client)" ]; then                              \
				echo "Installing openssh-client ...";                                                     \
				sudo apt-get -y install openssh-client;                                                   \
			fi;                                                                                           \
			if [ -z "$$(apt list --installed | grep openssh-server)" ]; then                              \
				echo "Installing openssh-server ...";                                                     \
				sudo apt-get -y install openssh-server;                                                   \
			fi;                                                                                           \
			cp $$PATH_SSHD_CONFIG /etc/ssh/sshd_config;                                                   \
			sudo systemctl restart sshd.service;                                                          \
			exit;                                                                                         \
		fi;                                                                                               \
		if [ -z "$$OS_ID" ]; then                                                                         \
			echo "Error: OS not supported";                                                               \
		else                                                                                              \
			echo "Error: $$OS_ID OS not supported";                                                       \
		fi;

