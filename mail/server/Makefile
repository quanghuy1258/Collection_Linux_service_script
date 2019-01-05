SHELL    := /bin/bash
PATH_PWD := $(shell pwd)
OS_ID    := $(shell cat /etc/os-release | grep "^ID=" | cut -c 4-)

help:
	@	echo "- Show help:                  $$ make help"
	@	echo "- Install dependencies:   (1) $$ sudo make install"
	@	echo "- Uninstall dependencies:     $$ sudo make uninstall"
	@	echo "- Configure:              (2) $$ sudo make configure"
	@	echo "- Start service:          (3) $$ sudo make start"
	@	echo "RECOMMEND: (1) -> (2) -> (3)"

install:
	@	if [ $$(id -u) -ne 0 ]; then                                            \
			echo "Error: Please run as root";                                   \
			exit;                                                               \
		fi;                                                                     \
		if [ "$(OS_ID)" = "ubuntu" ]; then                                      \
			if [ -z "$$(apt list --installed | grep "^postfix/")" ]; then       \
				echo "===== Install postfix =====";                             \
				apt-get -y install postfix;                                     \
			fi;                                                                 \
			if [ -z "$$(apt list --installed | grep "^dovecot-imapd/")" ]; then \
				echo "===== Install dovecot-imapd =====";                       \
				apt-get -y install dovecot-imapd;                               \
			fi;                                                                 \
			if [ -z "$$(apt list --installed | grep "^dovecot-pop3d/")" ]; then \
				echo "===== Install dovecot-pop3d =====";                       \
				apt-get -y install dovecot-pop3d;                               \
			fi;                                                                 \
			echo "===== Done =====";                                            \
			exit;                                                               \
		fi;                                                                     \
		if [ -z "$(OS_ID)" ]; then                                              \
			echo "Error: OS not supported";                                     \
		else                                                                    \
			echo "Error: $(OS_ID) OS not supported";                            \
		fi;

uninstall:
	@	if [ $$(id -u) -ne 0 ]; then                                                               \
			echo "Error: Please run as root";                                                      \
			exit;                                                                                  \
		fi;                                                                                        \
		if [ "$(OS_ID)" = "ubuntu" ]; then                                                         \
			if [ ! -z "$$(systemctl status postfix.service | grep "Active: active ")" ]; then      \
				echo "===== Stop postfix.service =====";                                           \
				systemctl stop postfix.service;                                                    \
			fi;                                                                                    \
			if [ ! -z "$$(systemctl status dovecot.service | grep "Active: active ")" ]; then      \
				echo "===== Stop dovecot.service =====";                                           \
				systemctl stop dovecot.service;                                                    \
			fi;                                                                                    \
			if [ ! -z "$$(apt list --installed | grep "^postfix/")" ]; then                        \
				echo "===== Uninstall postfix =====";                                              \
				apt-get -y purge postfix;                                                          \
			fi;                                                                                    \
			if [ ! -z "$$(apt list --installed | grep "^dovecot-imapd/")" ]; then                  \
				echo "===== Uninstall dovecot-imapd =====";                                        \
				apt-get -y purge dovecot-imapd;                                                    \
			fi;                                                                                    \
			if [ ! -z "$$(apt list --installed | grep "^dovecot-pop3d/")" ]; then                  \
				echo "===== Uninstall dovecot-pop3d =====";                                        \
				apt-get -y purge dovecot-pop3d;                                                    \
			fi;                                                                                    \
			echo "===== Done =====";                                                               \
			exit;                                                                                  \
		fi;                                                                                        \
		if [ -z "$(OS_ID)" ]; then                                                                 \
			echo "Error: OS not supported";                                                        \
		else                                                                                       \
			echo "Error: $(OS_ID) OS not supported";                                               \
		fi;

configure:
	@	if [ $$(id -u) -ne 0 ]; then                                                                           \
			echo "Error: Please run as root";                                                                  \
			exit;                                                                                              \
		fi;                                                                                                    \
		if [ "$(OS_ID)" = "ubuntu" ]; then                                                                     \
			echo "===== Reconfigure postfix =====";                                                            \
			dpkg-reconfigure postfix;                                                                          \
			echo "===== Done =====";                                                                           \
			exit;                                                                                              \
		fi;                                                                                                    \
		if [ -z "$(OS_ID)" ]; then                                                                             \
			echo "Error: OS not supported";                                                                    \
		else                                                                                                   \
			echo "Error: $(OS_ID) OS not supported";                                                           \
		fi;

start:
	@	if [ $$(id -u) -ne 0 ]; then                                                        \
			echo "Error: Please run as root";                                               \
			exit;                                                                           \
		fi;                                                                                 \
		if [ "$(OS_ID)" = "ubuntu" ]; then                                                  \
			if [ -z "$$(systemctl status postfix.service | grep "Active: active ")" ]; then \
				echo "===== Start postfix.service =====";                                   \
				sudo systemctl start postfix.service;                                       \
			else                                                                            \
				echo "===== Restart postfix.service =====";                                 \
				sudo systemctl restart postfix.service;                                     \
			fi;                                                                             \
			if [ -z "$$(systemctl status dovecot.service | grep "Active: active ")" ]; then \
				echo "===== Start dovecot.service =====";                                   \
				sudo systemctl start dovecot.service;                                       \
			else                                                                            \
				echo "===== Restart dovecot.service =====";                                 \
				sudo systemctl restart dovecot.service;                                     \
			fi;                                                                             \
			echo "===== Done =====";                                                        \
			exit;                                                                           \
		fi;                                                                                 \
		if [ -z "$(OS_ID)" ]; then                                                          \
			echo "Error: OS not supported";                                                 \
		else                                                                                \
			echo "Error: $(OS_ID) OS not supported";                                        \
		fi;
