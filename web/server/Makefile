SHELL    := /bin/bash
PATH_PWD := $(shell pwd)
OS_ID    := $(shell cat /etc/os-release | grep "^ID=" | cut -c 4-)

help:
	@	echo "- Show help:                    $$ make help"
	@	echo "- Install dependencies:     (1) $$ sudo make install"
	@	echo "- Uninstall dependencies:       $$ sudo make uninstall"
	@	echo "- Configure general:        (2) $$ sudo make configure"
	@	echo "- Configure virtual host:       $$ sudo make configure_host ADMIN={string} CA={string} DOMAIN={string} HOST={string}"
	@	echo "- Configure wordpress:          $$ sudo make configure_wordpress NAME={string} USER={string} PASSWORD={string} HOST={string}"
	@	echo "- Start:                    (3) $$ sudo make start"
	@	echo "RECOMMEND: (1) -> (2) -> (3)"

install:
	@	if [ $$(id -u) -ne 0 ]; then                                                      \
			echo "Error: Please run as root";                                             \
			exit;                                                                         \
		fi;                                                                               \
		if [ "$(OS_ID)" = "ubuntu" ]; then                                                \
			if [ -z "$$(apt list --installed | grep "^apache2/")" ]; then                 \
				echo "===== Install apache2 =====";                                       \
				sudo apt-get -y install apache2;                                          \
			fi;                                                                           \
			if [ -z "$$(apt list --installed | grep "^mysql-server/")" ]; then            \
				echo "===== Install mysql-server =====";                                  \
				sudo apt-get -y install mysql-server;                                     \
			fi;                                                                           \
			if [ -z "$$(apt list --installed | grep "^php/")" ]; then                     \
				echo "===== Install php =====";                                           \
				sudo apt-get -y install php libapache2-mod-php php-cli php-cgi php-mysql; \
			fi;                                                                           \
			if [ -z "$$(apt list --installed | grep "^openssl/")" ]; then                 \
				echo "===== Install openssl =====";                                       \
				sudo apt-get -y install openssl;                                          \
			fi;                                                                           \
			echo "===== Done =====";                                                      \
			exit;                                                                         \
		fi;                                                                               \
		if [ -z "$(OS_ID)" ]; then                                                        \
			echo "Error: OS not supported";                                               \
		else                                                                              \
			echo "Error: $(OS_ID) OS not supported";                                      \
		fi;

uninstall:
	@	if [ $$(id -u) -ne 0 ]; then                                                          \
			echo "Error: Please run as root";                                                 \
			exit;                                                                             \
		fi;                                                                                   \
		if [ "$(OS_ID)" = "ubuntu" ]; then                                                    \
			if [ ! -z "$$(systemctl status apache2.service | grep "Active: active ")" ]; then \
				echo "===== Stop apache2.service =====";                                      \
				systemctl stop apache2.service;                                               \
			fi;                                                                               \
			if [ ! -z "$$(systemctl status mysql.service | grep "Active: active ")" ]; then   \
				echo "===== Stop mysql.service =====";                                        \
				systemctl stop mysql.service;                                                 \
			fi;                                                                               \
			if [ ! -z "$$(apt list --installed | grep "^apache2/")" ]; then                   \
				echo "===== Uninstall apache2 =====";                                         \
				apt-get -y purge apache2;                                                     \
			fi;                                                                               \
			if [ ! -z "$$(apt list --installed | grep "^mysql-server/")" ]; then              \
				echo "===== Uninstall mysql-server =====";                                    \
				apt-get -y purge mysql-server;                                                \
			fi;                                                                               \
			if [ ! -z "$$(apt list --installed | grep "^php/")" ]; then                       \
				echo "===== Uninstall php =====";                                             \
				apt-get -y purge php libapache2-mod-php php-cli php-cgi php-mysql;            \
			fi;                                                                               \
			echo "===== Done =====";                                                          \
			exit;                                                                             \
		fi;                                                                                   \
		if [ -z "$(OS_ID)" ]; then                                                            \
			echo "Error: OS not supported";                                                   \
		else                                                                                  \
			echo "Error: $(OS_ID) OS not supported";                                          \
		fi;

configure:
	@	if [ $$(id -u) -ne 0 ]; then                                                                                             \
			echo "Error: Please run as root";                                                                                    \
			exit;                                                                                                                \
		fi;                                                                                                                      \
		if [ "$(OS_ID)" = "ubuntu" ]; then                                                                                       \
			echo "===== Configure =====";                                                                                        \
			echo "Info: Enable PHP in Apache2";                                                                                  \
			a2dismod php*;                                                                                                       \
			a2dismod mpm_*;                                                                                                      \
			a2enmod php*;                                                                                                        \
			echo "Info: Allow only localhost in default site for testing";                                                       \
			if [ -z "$$(cat /etc/apache2/sites-available/000-default.conf | grep " Configured: configure")" ]; then              \
				if [ -f /etc/apache2/sites-available/000-default.conf ] && [ ! -f $(PATH_PWD)/000-default.conf.bak ]; then       \
					cp /etc/apache2/sites-available/000-default.conf $(PATH_PWD)/000-default.conf.bak;                           \
				fi;                                                                                                              \
				rm /etc/apache2/sites-available/000-default.conf;                                                                \
				touch /etc/apache2/sites-available/000-default.conf;                                                             \
				while IFS='' read -r line || [[ -n "$$line" ]]; do                                                               \
					printf "%s\n" "$$line" >>/etc/apache2/sites-available/000-default.conf;                                      \
					if [ ! -z "$$(printf "%s" "$$line" | grep "DocumentRoot /var/www/html")" ]; then                             \
						printf "\t<Directory /var/www/html>\n" >>/etc/apache2/sites-available/000-default.conf;                  \
						printf "\t\tOrder deny,allow\n" >>/etc/apache2/sites-available/000-default.conf;                         \
						printf "\t\tDeny from all\n" >>/etc/apache2/sites-available/000-default.conf;                            \
						printf "\t\tAllow from 127.0.0.0/255.0.0.0 ::1/128\n" >>/etc/apache2/sites-available/000-default.conf;   \
						printf "\t</Directory>\n" >>/etc/apache2/sites-available/000-default.conf;                               \
					fi;                                                                                                          \
				done <$(PATH_PWD)/000-default.conf.bak;                                                                          \
				printf "%s\n" "# Configured: configure" >>/etc/apache2/sites-available/000-default.conf;                         \
			fi;                                                                                                                  \
			if [ -z "$$(cat /etc/apache2/sites-available/default-ssl.conf | grep " Configured: configure")" ]; then              \
				if [ -f /etc/apache2/sites-available/default-ssl.conf ] && [ ! -f $(PATH_PWD)/default-ssl.conf.bak ]; then       \
					cp /etc/apache2/sites-available/default-ssl.conf $(PATH_PWD)/default-ssl.conf.bak;                           \
				fi;                                                                                                              \
				rm /etc/apache2/sites-available/default-ssl.conf;                                                                \
				touch /etc/apache2/sites-available/default-ssl.conf;                                                             \
				while IFS='' read -r line || [[ -n "$$line" ]]; do                                                               \
					printf "%s\n" "$$line" >>/etc/apache2/sites-available/default-ssl.conf;                                      \
					if [ ! -z "$$(printf "%s" "$$line" | grep "DocumentRoot /var/www/html")" ]; then                             \
						printf "\t\t<Directory /var/www/html>\n" >>/etc/apache2/sites-available/000-default.conf;                \
						printf "\t\t\tOrder deny,allow\n" >>/etc/apache2/sites-available/default-ssl.conf;                       \
						printf "\t\t\tDeny from all\n" >>/etc/apache2/sites-available/default-ssl.conf;                          \
						printf "\t\t\tAllow from 127.0.0.0/255.0.0.0 ::1/128\n" >>/etc/apache2/sites-available/default-ssl.conf; \
						printf "\t\t</Directory>\n" >>/etc/apache2/sites-available/000-default.conf;                             \
					fi;                                                                                                          \
				done <$(PATH_PWD)/default-ssl.conf.bak;                                                                          \
				printf "%s\n" "# Configured: configure" >>/etc/apache2/sites-available/default-ssl.conf;                         \
			fi;                                                                                                                  \
			echo "Info: Enable SSL in Apache2";                                                                                  \
			a2enmod ssl;                                                                                                         \
			echo "===== Done =====";                                                                                             \
			exit;                                                                                                                \
		fi;                                                                                                                      \
		if [ -z "$(OS_ID)" ]; then                                                                                               \
			echo "Error: OS not supported";                                                                                      \
		else                                                                                                                     \
			echo "Error: $(OS_ID) OS not supported";                                                                             \
		fi;

configure_host:
	@	if [ $$(id -u) -ne 0 ]; then                                                                    \
			echo "Error: Please run as root";                                                           \
			exit;                                                                                       \
		fi;                                                                                             \
		if [ -z $(ADMIN) ]; then                                                                        \
			echo "Error: ADMIN arg is not set";                                                         \
			exit;                                                                                       \
		fi;                                                                                             \
		if [ -z $(CA) ]; then                                                                           \
			echo "Error: CA arg is not set";                                                            \
			exit;                                                                                       \
		fi;                                                                                             \
		if [ -z $(DOMAIN) ]; then                                                                       \
			echo "Error: DOMAIN arg is not set";                                                        \
			exit;                                                                                       \
		fi;                                                                                             \
		if [ -z $(HOST) ]; then                                                                         \
			echo "Error: HOST arg is not set";                                                          \
			exit;                                                                                       \
		fi;                                                                                             \
		if [ ! -f $(PATH_PWD)/$(HOST)/$(HOST).conf ]; then                                              \
			echo "Error: File $(HOST)/$(HOST).conf not found";                                          \
			exit;                                                                                       \
		fi;                                                                                             \
		if [ "$(OS_ID)" = "ubuntu" ]; then                                                              \
			while IFS='' read -r line || [[ -n "$$line" ]]; do                                          \
				if [ ! -z "$$(printf "%s" "$$line" | grep "ServerAdmin ")" ]; then                      \
					if [ -z "$$(printf "%s" "$$line" | grep " $(ADMIN)@$(DOMAIN)$$")" ]; then           \
						echo "Error: ServerAdmin -> Wrong";                                             \
						exit;                                                                           \
					fi;                                                                                 \
				fi;                                                                                     \
				if [ ! -z "$$(printf "%s" "$$line" | grep "ServerName ")" ]; then                       \
					if [ -z "$$(printf "%s" "$$line" | grep " $(DOMAIN)$$")" ]; then                    \
						echo "Error: ServerName -> Wrong";                                              \
						exit;                                                                           \
					fi;                                                                                 \
				fi;                                                                                     \
				if [ ! -z "$$(printf "%s" "$$line" | grep "ServerAlias ")" ]; then                      \
					if [ -z "$$(printf "%s" "$$line" | grep " $(HOST)$$")" ]; then                      \
						echo "Error: ServerAlias -> Wrong";                                             \
						exit;                                                                           \
					fi;                                                                                 \
				fi;                                                                                     \
				if [ ! -z "$$(printf "%s" "$$line" | grep "DocumentRoot ")" ]; then                     \
					if [ -z "$$(printf "%s" "$$line" | grep " /var/www/html/$(HOST)$$")" ]; then        \
						echo "Error: DocumentRoot -> Wrong";                                            \
						exit;                                                                           \
					fi;                                                                                 \
				fi;                                                                                     \
				if [ ! -z "$$(printf "%s" "$$line" | grep "Redirect permanent / ")" ]; then             \
					if [ -z "$$(printf "%s" "$$line" | grep " https://$(HOST)/$$")" ]; then             \
						echo "Error: Redirect permanent -> Wrong";                                      \
						exit;                                                                           \
					fi;                                                                                 \
				fi;                                                                                     \
				if [ ! -z "$$(printf "%s" "$$line" | grep "SSLEngine ")" ]; then                        \
					if [ -z "$$(printf "%s" "$$line" | grep " on$$")" ]; then                           \
						echo "Error: SSLEngine -> Wrong";                                               \
						exit;                                                                           \
					fi;                                                                                 \
				fi;                                                                                     \
				if [ ! -z "$$(printf "%s" "$$line" | grep "SSLCertificateFile ")" ]; then               \
					if [ -z "$$(printf "%s" "$$line" | grep " /etc/ssl/certs/$(HOST).pem$$")" ]; then   \
						echo "Error: SSLCertificateFile -> Wrong";                                      \
						exit;                                                                           \
					fi;                                                                                 \
				fi;                                                                                     \
				if [ ! -z "$$(printf "%s" "$$line" | grep "SSLCertificateKeyFile ")" ]; then            \
					if [ -z "$$(printf "%s" "$$line" | grep " /etc/ssl/private/$(HOST).key$$")" ]; then \
						echo "Error: SSLCertificateKeyFile -> Wrong";                                   \
						exit;                                                                           \
					fi;                                                                                 \
				fi;                                                                                     \
				if [ ! -z "$$(printf "%s" "$$line" | grep "SSLCertificateChainFile ")" ]; then          \
					if [ -z "$$(printf "%s" "$$line" | grep " /etc/ssl/certs/$(CA).pem$$")" ]; then     \
						echo "Error: SSLCertificateChainFile -> Wrong";                                 \
						exit;                                                                           \
					fi;                                                                                 \
				fi;                                                                                     \
			done <$(PATH_PWD)/$(HOST)/$(HOST).conf;                                                     \
			cp $(PATH_PWD)/$(HOST)/$(HOST).pem /etc/ssl/certs/$(HOST).pem;                              \
			cp $(PATH_PWD)/$(HOST)/$(HOST).key /etc/ssl/private/$(HOST).key;                            \
			if [ -f $(PATH_PWD)/$(HOST)/$(CA).pem ]; then                                               \
				cp $(PATH_PWD)/$(HOST)/$(CA).pem /etc/ssl/certs/$(CA).pem;                              \
			else                                                                                        \
				if [ ! -f /etc/ssl/certs/$(CA).pem ]; then                                              \
					echo "Error: File /etc/ssl/certs/$(CA).pem not found";                              \
					exit;                                                                               \
				fi;                                                                                     \
			fi;                                                                                         \
			hash=$$(openssl x509 -noout -hash -in /etc/ssl/certs/$(CA).pem);                            \
			rm -rf /etc/ssl/certs/$$hash.0;                                                             \
			ln -s /etc/ssl/certs/cacert.pem /etc/ssl/certs/$$hash.0;                                    \
			cp $(PATH_PWD)/$(HOST)/$(HOST).conf /etc/apache2/sites-available/;                          \
			a2ensite $(HOST);                                                                           \
			mkdir -p /var/www/html/$(HOST);                                                             \
			chown -R www-data:www-data /var/www/html/$(HOST);                                           \
			chmod -R 755 /var/www/html/$(HOST);                                                         \
			echo "===== Done =====";                                                                    \
			exit;                                                                                       \
		fi;                                                                                             \
		if [ -z "$(OS_ID)" ]; then                                                                      \
			echo "Error: OS not supported";                                                             \
		else                                                                                            \
			echo "Error: $(OS_ID) OS not supported";                                                    \
		fi;

configure_wordpress:
	@	if [ $$(id -u) -ne 0 ]; then                                                           \
			echo "Error: Please run as root";                                                  \
			exit;                                                                              \
		fi;                                                                                    \
		if [ -z $(NAME) ]; then                                                                \
			echo "Error: NAME arg is not set";                                                 \
			exit;                                                                              \
		fi;                                                                                    \
		if [ -z $(USER) ]; then                                                                \
			echo "Error: USER arg is not set";                                                 \
			exit;                                                                              \
		fi;                                                                                    \
		if [ -z $(PASSWORD) ]; then                                                            \
			echo "Error: PASSWORD arg is not set";                                             \
			exit;                                                                              \
		fi;                                                                                    \
		if [ -z $(HOST) ]; then                                                                \
			echo "Error: DB_HOST arg is not set";                                              \
			exit;                                                                              \
		fi;                                                                                    \
		if [ ! -f /etc/apache2/sites-available/$(HOST).conf ]; then                            \
			echo "Error: Site $(HOST) is not set";                                             \
			exit;                                                                              \
		fi;                                                                                    \
		if [ "$(OS_ID)" = "ubuntu" ]; then                                                     \
			if [ -z "$$(systemctl status mysql.service | grep "Active: active ")" ]; then      \
				echo "===== Start mysql.service =====";                                        \
				systemctl start mysql.service;                                                 \
			fi;                                                                                \
			sed -re "s/database_name_here/$(NAME)/g" -i $(PATH_PWD)/wordpress.sql;             \
			sed -re "s/username_here/$(USER)/g" -i  $(PATH_PWD)/wordpress.sql;                 \
			sed -re "s/password_here/$(PASSWORD)/g" -i  $(PATH_PWD)/wordpress.sql;             \
			cat wordpress.sql | sudo mysql --defaults-extra-file=/etc/mysql/debian.cnf;        \
			wget http://wordpress.org/latest.tar.gz;                                           \
			tar -xf latest.tar.gz;                                                             \
			cp -R wordpress/* /var/www/html/$(HOST)/;                                          \
			rm -rf latest.tar.gz wordpress;                                                    \
			cp /var/www/html/$(HOST)/wp-config-sample.php /var/www/html/$(HOST)/wp-config.php; \
			sed -re "s/database_name_here/$(NAME)/g" -i /var/www/html/$(HOST)/wp-config.php;   \
			sed -re "s/username_here/$(USER)/g" -i /var/www/html/$(HOST)/wp-config.php;        \
			sed -re "s/password_here/$(PASSWORD)/g" -i /var/www/html/$(HOST)/wp-config.php;    \
			echo "===== Done =====";                                                           \
			exit;                                                                              \
		fi;                                                                                    \
		if [ -z "$(OS_ID)" ]; then                                                             \
			echo "Error: OS not supported";                                                    \
		else                                                                                   \
			echo "Error: $(OS_ID) OS not supported";                                           \
		fi;

start:
	@	if [ $$(id -u) -ne 0 ]; then                                                        \
			echo "Error: Please run as root";                                               \
			exit;                                                                           \
		fi;                                                                                 \
		if [ "$(OS_ID)" = "ubuntu" ]; then                                                  \
			if [ -z "$$(systemctl status apache2.service | grep "Active: active ")" ]; then \
				echo "===== Start apache2.service =====";                                   \
				systemctl start apache2.service;                                            \
			else                                                                            \
				echo "===== Restart apache2.service =====";                                 \
				systemctl restart apache2.service;                                          \
			fi;                                                                             \
			if [ -z "$$(systemctl status mysql.service | grep "Active: active ")" ]; then   \
				echo "===== Start mysql.service =====";                                     \
				systemctl start mysql.service;                                              \
			else                                                                            \
				echo "===== Restart mysql.service =====";                                   \
				systemctl restart mysql.service;                                            \
			fi;                                                                             \
			echo "===== Done =====";                                                        \
			exit;                                                                           \
		fi;                                                                                 \
		if [ -z "$(OS_ID)" ]; then                                                          \
			echo "Error: OS not supported";                                                 \
		else                                                                                \
			echo "Error: $(OS_ID) OS not supported";                                        \
		fi;
