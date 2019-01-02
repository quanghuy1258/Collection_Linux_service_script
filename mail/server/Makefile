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
			if [ -z "$$(apt list --installed | grep "^dovecot-core/")" ]; then  \
				echo "===== Install dovecot-core =====";                        \
				apt-get -y install dovecot-core;                                \
			fi;                                                                 \
			if [ -z "$$(apt list --installed | grep "^dovecot-imapd/")" ]; then \
				echo "===== Install dovecot-imapd =====";                       \
				apt-get -y install dovecot-imapd;                               \
			fi;                                                                 \
			if [ -z "$$(apt list --installed | grep "^dovecot-pop3d/")" ]; then \
				echo "===== Install dovecot-pop3d =====";                       \
				apt-get -y install dovecot-pop3d;                               \
			fi;                                                                 \
			if [ -z "$$(apt list --installed | grep "^squirrelmail/")" ]; then  \
				echo "===== Install squirrelmail =====";                        \
				apt-get -y install squirrelmail;                                \
			fi;                                                                 \
			if [ -z "$$(apt list --installed | grep "^amavisd-new/")" ]; then   \
				echo "===== Install amavisd-new =====";                         \
				apt-get -y install amavisd-new;                                 \
			fi;                                                                 \
			if [ -z "$$(apt list --installed | grep "^spamassassin/")" ]; then  \
				echo "===== Install spamassassin =====";                        \
				apt-get -y install spamassassin;                                \
			fi;                                                                 \
			if [ -z "$$(apt list --installed | grep "^clamav-daemon/")" ]; then \
				echo "===== Install clamav-daemon =====";                       \
				apt-get -y install clamav-daemon;                               \
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
			if [ ! -z "$$(systemctl status amavis.service | grep "Active: active ")" ]; then       \
				echo "===== Stop amavis.service =====";                                            \
				systemctl stop amavis.service;                                                     \
			fi;                                                                                    \
			if [ ! -z "$$(systemctl status spamassassin.service | grep "Active: active ")" ]; then \
				echo "===== Stop spamassassin.service =====";                                      \
				systemctl stop spamassassin.service;                                               \
			fi;                                                                                    \
			if [ ! -z "$$(apt list --installed | grep "^postfix/")" ]; then                        \
				echo "===== Uninstall postfix =====";                                              \
				apt-get -y purge postfix;                                                          \
			fi;                                                                                    \
			if [ ! -z "$$(apt list --installed | grep "^dovecot-core/")" ]; then                   \
				echo "===== Uninstall dovecot-core =====";                                         \
				apt-get -y purge dovecot-core;                                                     \
			fi;                                                                                    \
			if [ ! -z "$$(apt list --installed | grep "^dovecot-imapd/")" ]; then                  \
				echo "===== Uninstall dovecot-imapd =====";                                        \
				apt-get -y purge dovecot-imapd;                                                    \
			fi;                                                                                    \
			if [ ! -z "$$(apt list --installed | grep "^dovecot-pop3d/")" ]; then                  \
				echo "===== Uninstall dovecot-pop3d =====";                                        \
				apt-get -y purge dovecot-pop3d;                                                    \
			fi;                                                                                    \
			if [ ! -z "$$(apt list --installed | grep "^squirrelmail/")" ]; then                   \
				echo "===== Uninstall squirrelmail =====";                                         \
				apt-get -y purge squirrelmail;                                                     \
			fi;                                                                                    \
			if [ ! -z "$$(apt list --installed | grep "^amavisd-new/")" ]; then                    \
				echo "===== Uninstall amavisd-new =====";                                          \
				apt-get -y purge amavisd-new;                                                      \
			fi;                                                                                    \
			if [ ! -z "$$(apt list --installed | grep "^spamassassin/")" ]; then                   \
				echo "===== Uninstall spamassassin =====";                                         \
				apt-get -y purge spamassassin;                                                     \
			fi;                                                                                    \
			if [ ! -z "$$(apt list --installed | grep "^clamav-daemon/")" ]; then                  \
				echo "===== Uninstall clamav-daemon =====";                                        \
				apt-get -y purge clamav-daemon;                                                    \
			fi;                                                                                    \
			echo "===== Done =====";                                                               \
			exit;                                                                                  \
		fi;                                                                                        \
		if [ -z "$(OS_ID)" ]; then                                                                 \
			echo "Error: OS not supported";                                                        \
		else                                                                                       \
			echo "Error: $(OS_ID) OS not supported";                                               \
		fi;

