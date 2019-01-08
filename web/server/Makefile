SHELL    := /bin/bash
PATH_PWD := $(shell pwd)
OS_ID    := $(shell cat /etc/os-release | grep "^ID=" | cut -c 4-)

help:
	@	echo "- Show help:                    $$ make help"
	@	echo "- Install dependencies:     (1) $$ sudo make install"
	@	echo "- Uninstall dependencies:       $$ sudo make uninstall"
	@	echo "- Configure general:        (2) $$ sudo make configure"
	@	echo "- Configure virtual host:       $$ sudo make configure_host NAME_OF_YOUR_VIRTUAL_HOST={string} DB_PASSWORD={string}"
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
	@	if [ $$(id -u) -ne 0 ]; then                                                                     \
			echo "Error: Please run as root";                                                            \
			exit;                                                                                        \
		fi;                                                                                              \
		if [ ! -f $(PATH_PWD)/wordpress/wordpress.conf ]; then                                           \
			echo "Error: File wordpress/wordpress.conf not found";                                       \
			exit;                                                                                        \
		fi;                                                                                              \
		if [ "$(OS_ID)" = "ubuntu" ]; then                                                               \
			echo "===== Configure =====";                                                                \
			echo "Info: Enable PHP in Apache2";                                                          \
			a2dismod mpm_*;                                                                              \
			a2enmod php*;                                                                                \
			echo "Info: Configure wordpress";                                                            \
			cp $(PATH_PWD)/wordpress/wordpress.conf /etc/apache2/sites-available/wordpress.conf;         \
			a2ensite wordpress;                                                                          \
			echo "===== Done =====";                                                                     \
			exit;                                                                                        \
		fi;                                                                                              \
		if [ -z "$(OS_ID)" ]; then                                                                       \
			echo "Error: OS not supported";                                                              \
		else                                                                                             \
			echo "Error: $(OS_ID) OS not supported";                                                     \
		fi;

configure_host:
	@	if [ $$(id -u) -ne 0 ]; then                                                                              \
			echo "Error: Please run as root";                                                                     \
			exit;                                                                                                 \
		fi;                                                                                                       \
		if [ -z $(NAME_OF_YOUR_VIRTUAL_HOST) ]; then                                                              \
			echo "Error: NAME_OF_YOUR_VIRTUAL_HOST arg is not set";                                               \
			exit;                                                                                                 \
		fi;                                                                                                       \
		if [ -z $(DB_PASSWORD) ]; then                                                                            \
			echo "Error: DB_PASSWORD arg is not set";                                                             \
			exit;                                                                                                 \
		fi;                                                                                                       \
		if [ ! -f $(PATH_PWD)/wordpress/config-localhost.php ]; then                                              \
			echo "Error: File wordpress/config-localhost.php not found";                                          \
			exit;                                                                                                 \
		fi;                                                                                                       \
		if [ ! -f $(PATH_PWD)/wordpress/wordpress.sql ]; then                                                     \
			echo "Error: File wordpress/wordpress.sql not found";                                                 \
			exit;                                                                                                 \
		fi;                                                                                                       \
		if [ "$(OS_ID)" = "ubuntu" ]; then                                                                        \
			echo "===== Configure host =====";                                                                    \
			sed -re "s/yourpasswordhere/$(DB_PASSWORD)/g" -i $(PATH_PWD)/wordpress/config-localhost.php;          \
			sed -re "s/yourpasswordhere/$(DB_PASSWORD)/g" -i $(PATH_PWD)/wordpress/wordpress.sql;                 \
			sed -re "s/localhost/$(NAME_OF_YOUR_VIRTUAL_HOST)/g" -i $(PATH_PWD)/wordpress/config-localhost.php;   \
			sed -re "s/localhost/$(NAME_OF_YOUR_VIRTUAL_HOST)/g" -i $(PATH_PWD)/wordpress/wordpress.sql;          \
			cp $(PATH_PWD)/wordpress/config-localhost.php /etc/wordpress/config-$(NAME_OF_YOUR_VIRTUAL_HOST).php; \
			if [ -z "$$(systemctl status mysql.service | grep "Active: active ")" ]; then                         \
				echo "===== Start mysql.service =====";                                                           \
				systemctl start mysql.service;                                                                    \
			fi;                                                                                                   \
			cat $(PATH_PWD)/wordpress/wordpress.sql | mysql --defaults-extra-file=/etc/mysql/debian.cnf;          \
			echo "===== Done =====";                                                                              \
			exit;                                                                                                 \
		fi;                                                                                                       \
		if [ -z "$(OS_ID)" ]; then                                                                                \
			echo "Error: OS not supported";                                                                       \
		else                                                                                                      \
			echo "Error: $(OS_ID) OS not supported";                                                              \
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
