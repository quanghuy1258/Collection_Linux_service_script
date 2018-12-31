# Using Makefile instead of bash script

SHELL := /bin/bash

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
		OS_ID=$$(cat /etc/os-release | grep "^ID=" | cut -c 4-);                                          \
		if [ "$$OS_ID" = "ubuntu" ]; then                                                                 \
			if [ -z "$$(apt list --installed | grep "^apache2/")" ]; then                                 \
				echo "Installing apache2 ...";                                                            \
				sudo apt-get -y install apache2;                                                          \
			fi;                                                                                           \
			if [ -z "$$(apt list --installed | grep "^mysql-server/")" ]; then                            \
				echo "Installing mysql-server ...";                                                       \
				sudo apt-get -y install mysql-server;                                                     \
			fi;                                                                                           \
			if [ -z "$$(apt list --installed | grep "^wordpress/")" ]; then                               \
				echo "Installing wordpress ...";                                                          \
				sudo apt-get -y install wordpress;                                                        \
			fi;                                                                                           \
			exit;                                                                                         \
		fi;                                                                                               \
		if [ -z "$$OS_ID" ]; then                                                                         \
			echo "Error: OS not supported";                                                               \
		else                                                                                              \
			echo "Error: $$OS_ID OS not supported";                                                       \
		fi;
