SHELL    := /bin/bash
PATH_PWD := $$(pwd)

help:
	@	echo "- Show help:                  $$ make help"
	@	echo "- Install dependencies:   (1) $$ sudo make install"
	@	echo "- Uninstall dependencies:     $$ sudo make uninstall"
	@	echo "- Configure:              (2) $$ sudo make configure"
	@	echo "- Start service:          (3) $$ sudo make start"
	@	echo "RECOMMEND: (1) -> (2) -> (3)"

install:
	@	if [ $$(id -u) -ne 0 ]; then                                             \
			echo "Error: Please run as root";                                    \
			exit;                                                                \
		fi;                                                                      \
		OS_ID=$$(cat /etc/os-release | grep "^ID=" | cut -c 4-);                 \
		if [ "$$OS_ID" = "ubuntu" ]; then                                        \
			if [ -z "$$(apt list --installed | grep "^openssh-client/")" ]; then \
				echo "===== Install openssh-client =====";                       \
				apt-get -y install openssh-client;                               \
			fi;                                                                  \
			if [ -z "$$(apt list --installed | grep "^openssh-server/")" ]; then \
				echo "===== Install openssh-server =====";                       \
				apt-get -y install openssh-server;                               \
			fi;                                                                  \
			echo "===== Done =====";                                             \
			exit;                                                                \
		fi;                                                                      \
		if [ -z "$$OS_ID" ]; then                                                \
			echo "Error: OS not supported";                                      \
		else                                                                     \
			echo "Error: $$OS_ID OS not supported";                              \
		fi;

uninstall:
	@	if [ $$(id -u) -ne 0 ]; then                                               \
			echo "Error: Please run as root";                                      \
			exit;                                                                  \
		fi;                                                                        \
		OS_ID=$$(cat /etc/os-release | grep "^ID=" | cut -c 4-);                   \
		if [ "$$OS_ID" = "ubuntu" ]; then                                          \
			if [ ! -z "$$(apt list --installed | grep "^openssh-server/")" ]; then \
				echo "===== Uninstall openssh-server =====";                       \
				apt-get -y purge openssh-server;                                   \
			fi;                                                                    \
			echo "===== Done =====";                                               \
			exit;                                                                  \
		fi;                                                                        \
		if [ -z "$$OS_ID" ]; then                                                  \
			echo "Error: OS not supported";                                        \
		else                                                                       \
			echo "Error: $$OS_ID OS not supported";                                \
		fi;

configure:
	@	if [ $$(id -u) -ne 0 ]; then                                                                           \
			echo "Error: Please run as root";                                                                  \
			exit;                                                                                              \
		fi;                                                                                                    \
		if [ ! -z "$$(shasum $(PATH_PWD)/sshd_config | grep 37503d2ac009c25f88f86a4961be83d0944afcd6)" ]; then \
			echo "Warning: Please modify sshd_config file";                                                    \
			read -r -p "Continue? [y/N] " response;                                                            \
			if [ -z "$$(echo $$response | grep -E "^([yY][eE][sS]|y)$$")" ]; then                              \
				exit;                                                                                          \
			fi;                                                                                                \
		fi;                                                                                                    \
		OS_ID=$$(cat /etc/os-release | grep "^ID=" | cut -c 4-);                                               \
		if [ "$$OS_ID" = "ubuntu" ]; then                                                                      \
			cp $(PATH_PWD)/sshd_config /etc/ssh/sshd_config;                                                   \
			echo "===== Done =====";                                                                           \
			exit;                                                                                              \
		fi;                                                                                                    \
		if [ -z "$$OS_ID" ]; then                                                                              \
			echo "Error: OS not supported";                                                                    \
		else                                                                                                   \
			echo "Error: $$OS_ID OS not supported";                                                            \
		fi;

start:
	@	if [ $$(id -u) -ne 0 ]; then                                                                 \
			echo "Error: Please run as root";                                                        \
			exit;                                                                                    \
		fi;                                                                                          \
		OS_ID=$$(cat /etc/os-release | grep "^ID=" | cut -c 4-);                                     \
		if [ "$$OS_ID" = "ubuntu" ]; then                                                            \
			if [ -z "$$(systemctl status sshd.service | grep -E "Active: active (running)")" ]; then \
				sudo systemctl start sshd.service;                                                   \
			else                                                                                     \
				sudo systemctl restart sshd.service;                                                 \
			fi;                                                                                      \
			echo "===== Done =====";                                                                 \
			exit;                                                                                    \
		fi;                                                                                          \
		if [ -z "$$OS_ID" ]; then                                                                    \
			echo "Error: OS not supported";                                                          \
		else                                                                                         \
			echo "Error: $$OS_ID OS not supported";                                                  \
		fi;
