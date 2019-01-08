SHELL    := /bin/bash
PATH_PWD := $(shell pwd)
OS_ID    := $(shell cat /etc/os-release | grep "^ID=" | cut -c 4-)

help:
	@	echo "- Show help:                    $$ make help"
	@	echo "- Install dependencies:     (1) $$ sudo make install"
	@	echo "- Uninstall dependencies:       $$ sudo make uninstall"
	@	echo "- Configure:                (2) $$ sudo make configure"
	@	echo "- Start:                    (3) $$ sudo make start"
	@	echo "RECOMMEND: (1) -> (2) -> (3)"

install:
	@	if [ $$(id -u) -ne 0 ]; then                                                                      \
			echo "Error: Please run as root";                                                             \
			exit;                                                                                         \
		fi;                                                                                               \
		if [ "$(OS_ID)" = "ubuntu" ]; then                                                                \
			if [ -z "$$(apt list --installed | grep "^apache2/")" ]; then                                 \
				echo "===== Install apache2 =====";                                                       \
				sudo apt-get -y install apache2;                                                          \
			fi;                                                                                           \
			if [ -z "$$(apt list --installed | grep "^mysql-server/")" ]; then                            \
				echo "===== Install mysql-server =====";                                                  \
				sudo apt-get -y install mysql-server;                                                     \
			fi;                                                                                           \
			if [ -z "$$(apt list --installed | grep "^php/")" ]; then                                     \
				echo "===== Install php =====";                                                           \
				sudo apt-get -y install php libapache2-mod-php php-cli php-cgi php-mysql;                 \
			fi;                                                                                           \
			if [ -z "$$(apt list --installed | grep "^wordpress/")" ]; then                               \
				echo "===== Install wordpress =====";                                                     \
				sudo apt-get -y install wordpress;                                                        \
			fi;                                                                                           \
			echo "===== Done =====";                                                                      \
			exit;                                                                                         \
		fi;                                                                                               \
		if [ -z "$(OS_ID)" ]; then                                                                        \
			echo "Error: OS not supported";                                                               \
		else                                                                                              \
			echo "Error: $(OS_ID) OS not supported";                                                      \
		fi;

uninstall:
	@	if [ $$(id -u) -ne 0 ]; then                                                                \
			echo "Error: Please run as root";                                                       \
			exit;                                                                                   \
		fi;                                                                                         \
		if [ "$(OS_ID)" = "ubuntu" ]; then                                                          \
			if [ ! -z "$$(systemctl status apache2.service | grep "Active: active ")" ]; then       \
				echo "===== Stop apache2.service =====";                                            \
				systemctl stop apache2.service;                                                     \
			fi;                                                                                     \
			if [ ! -z "$$(systemctl status mysql.service | grep "Active: active ")" ]; then         \
				echo "===== Stop mysql.service =====";                                              \
				systemctl stop mysql.service;                                                       \
			fi;                                                                                     \
			if [ ! -z "$$(apt list --installed | grep "^apache2/")" ]; then                         \
				echo "===== Uninstall apache2 =====";                                               \
				apt-get -y purge apache2;                                                           \
			fi;                                                                                     \
			if [ ! -z "$$(apt list --installed | grep "^mysql-server/")" ]; then                    \
				echo "===== Uninstall mysql-server =====";                                          \
				apt-get -y purge mysql-server;                                                      \
			fi;                                                                                     \
			if [ ! -z "$$(apt list --installed | grep "^php/")" ]; then                             \
				echo "===== Uninstall php =====";                                                   \
				apt-get -y purge php libapache2-mod-php php-cli php-cgi php-mysql;                  \
			fi;                                                                                     \
			if [ ! -z "$$(apt list --installed | grep "^wordpress/")" ]; then                       \
				echo "===== Uninstall wordpress =====";                                             \
				apt-get -y purge wordpress;                                                         \
			fi;                                                                                     \
			echo "===== Done =====";                                                                \
			exit;                                                                                   \
		fi;                                                                                         \
		if [ -z "$(OS_ID)" ]; then                                                                  \
			echo "Error: OS not supported";                                                         \
		else                                                                                        \
			echo "Error: $(OS_ID) OS not supported";                                                \
		fi;

configure:
	@	if [ $$(id -u) -ne 0 ]; then                                                                \
			echo "Error: Please run as root";                                                       \
			exit;                                                                                   \
		fi;                                                                                         \
		if [ "$(OS_ID)" = "ubuntu" ]; then                                                          \
			echo "===== Configure =====";                                                           \
			echo "Info: Enable PHP in Apache2";                                                     \
			a2dismod mpm_*;                                                                         \
			a2enmod php*;                                                                           \
			echo "===== Done =====";                                                                \
			exit;                                                                                   \
		fi;                                                                                         \
		if [ -z "$(OS_ID)" ]; then                                                                  \
			echo "Error: OS not supported";                                                         \
		else                                                                                        \
			echo "Error: $(OS_ID) OS not supported";                                                \
		fi;

start:
	@	if [ $$(id -u) -ne 0 ]; then                                                                \
			echo "Error: Please run as root";                                                       \
			exit;                                                                                   \
		fi;                                                                                         \
		if [ "$(OS_ID)" = "ubuntu" ]; then                                                          \
			if [ -z "$$(systemctl status apache2.service | grep "Active: active ")" ]; then         \
				echo "===== Start apache2.service =====";                                           \
				systemctl start apache2.service;                                                    \
			else                                                                                    \
				echo "===== Restart apache2.service =====";                                         \
				systemctl restart apache2.service;                                                  \
			fi;                                                                                     \
			if [ -z "$$(systemctl status mysql.service | grep "Active: active ")" ]; then           \
				echo "===== Start mysql.service =====";                                             \
				systemctl start mysql.service;                                                      \
			else                                                                                    \
				echo "===== Restart mysql.service =====";                                           \
				systemctl restart mysql.service;                                                    \
			fi;                                                                                     \
			echo "===== Done =====";                                                                \
			exit;                                                                                   \
		fi;                                                                                         \
		if [ -z "$(OS_ID)" ]; then                                                                  \
			echo "Error: OS not supported";                                                         \
		else                                                                                        \
			echo "Error: $(OS_ID) OS not supported";                                                \
		fi;
