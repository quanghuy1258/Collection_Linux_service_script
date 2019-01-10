SHELL    := /bin/bash
PATH_PWD := $(shell pwd)
OS_ID    := $(shell cat /etc/os-release | grep "^ID=" | cut -c 4-)

help:
	@	echo "- Show help:                    $$ make help"
	@	echo "- Install dependencies:     (1) $$ sudo make install"
	@	echo "- Uninstall dependencies:       $$ sudo make uninstall"
	@	echo "- Configure postfix:        (2) $$ sudo make configure_postfix"
	@	echo "- Configure mail filtering: (3) $$ sudo make configure_filtering"
	@	echo "- Configure SSL:            (4) $$ sudo make configure_ssl MYHOSTNAME={string}"
	@	echo "- Start service:            (5) $$ sudo make start"
	@	echo "- For only squirrelmail:        $$ sudo make only_squirrelmail CMD={string}"
	@	echo "RECOMMEND: (1) -> (2) -> (3) -> (4) -> (5)"

install:
	@	if [ $$(id -u) -ne 0 ]; then                                            \
			echo "Error: Please run as root";                                   \
			exit;                                                               \
		fi;                                                                     \
		if [ "$(OS_ID)" = "ubuntu" ]; then                                      \
			if [ -z "$$(apt list --installed | grep "^openssl/")" ]; then       \
				echo "===== Install openssl =====";                             \
				apt-get -y install openssl;                                     \
			fi;                                                                 \
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
			if [ -z "$$(apt list --installed | grep "^dovecot-core/")" ]; then  \
				echo "===== Install dovecot-core =====";                        \
				apt-get -y install dovecot-core;                                \
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
	@	if [ $$(id -u) -ne 0 ]; then                                                                \
			echo "Error: Please run as root";                                                       \
			exit;                                                                                   \
		fi;                                                                                         \
		if [ "$(OS_ID)" = "ubuntu" ]; then                                                          \
			if [ ! -z "$$(systemctl status postfix.service | grep "Active: active ")" ]; then       \
				echo "===== Stop postfix.service =====";                                            \
				systemctl stop postfix.service;                                                     \
			fi;                                                                                     \
			if [ ! -z "$$(systemctl status dovecot.service | grep "Active: active ")" ]; then       \
				echo "===== Stop dovecot.service =====";                                            \
				systemctl stop dovecot.service;                                                     \
			fi;                                                                                     \
			if [ ! -z "$$(systemctl status spamassassin.service | grep "Active: active ")" ]; then  \
				echo "===== Stop spamassassin.service =====";                                       \
				systemctl stop spamassassin.service;                                                \
			fi;                                                                                     \
			if [ ! -z "$$(systemctl status amavis.service | grep "Active: active ")" ]; then        \
				echo "===== Stop amavis.service =====";                                             \
				systemctl stop amavis.service;                                                      \
			fi;                                                                                     \
			if [ ! -z "$$(systemctl status clamav-daemon.service | grep "Active: active ")" ]; then \
				echo "===== Stop clamav-daemon.service =====";                                      \
				systemctl stop clamav-daemon.service;                                               \
			fi;                                                                                     \
			if [ ! -z "$$(apt list --installed | grep "^postfix/")" ]; then                         \
				echo "===== Uninstall postfix =====";                                               \
				apt-get -y purge postfix;                                                           \
			fi;                                                                                     \
			if [ ! -z "$$(apt list --installed | grep "^dovecot-imapd/")" ]; then                   \
				echo "===== Uninstall dovecot-imapd =====";                                         \
				apt-get -y purge dovecot-imapd;                                                     \
			fi;                                                                                     \
			if [ ! -z "$$(apt list --installed | grep "^dovecot-pop3d/")" ]; then                   \
				echo "===== Uninstall dovecot-pop3d =====";                                         \
				apt-get -y purge dovecot-pop3d;                                                     \
			fi;                                                                                     \
			if [ ! -z "$$(apt list --installed | grep "^amavisd-new/")" ]; then                     \
				echo "===== Uninstall amavisd-new =====";                                           \
				apt-get -y purge amavisd-new;                                                       \
			fi;                                                                                     \
			if [ ! -z "$$(apt list --installed | grep "^spamassassin/")" ]; then                    \
				echo "===== Uninstall spamassassin =====";                                          \
				apt-get -y purge spamassassin;                                                      \
			fi;                                                                                     \
			if [ ! -z "$$(apt list --installed | grep "^clamav-daemon/")" ]; then                   \
				echo "===== Uninstall clamav-daemon =====";                                         \
				apt-get -y purge clamav-daemon;                                                     \
			fi;                                                                                     \
			if [ ! -z "$$(apt list --installed | grep "^dovecot-core/")" ]; then                    \
				echo "===== Uninstall dovecot-core =====";                                          \
				apt-get -y purge dovecot-core;                                                      \
			fi;                                                                                     \
			echo "===== Done =====";                                                                \
			exit;                                                                                   \
		fi;                                                                                         \
		if [ -z "$(OS_ID)" ]; then                                                                  \
			echo "Error: OS not supported";                                                         \
		else                                                                                        \
			echo "Error: $(OS_ID) OS not supported";                                                \
		fi;

configure_postfix:
	@	if [ $$(id -u) -ne 0 ]; then                 \
			echo "Error: Please run as root";        \
			exit;                                    \
		fi;                                          \
		if [ "$(OS_ID)" = "ubuntu" ]; then           \
			echo "===== Configure postfix =====";    \
			dpkg-reconfigure postfix;                \
			echo "===== Done =====";                 \
			exit;                                    \
		fi;                                          \
		if [ -z "$(OS_ID)" ]; then                   \
			echo "Error: OS not supported";          \
		else                                         \
			echo "Error: $(OS_ID) OS not supported"; \
		fi;

# Explanation of read line: https://stackoverflow.com/a/10929511
configure_filtering:
	@	if [ $$(id -u) -ne 0 ]; then                                                                                       \
			echo "Error: Please run as root";                                                                              \
			exit;                                                                                                          \
		fi;                                                                                                                \
		if [ "$(OS_ID)" = "ubuntu" ]; then                                                                                 \
			echo "===== Configure mail filtering =====";                                                                   \
			if [ ! -z "$$(shasum $(PATH_PWD)/amavisd-new/50-user | grep 20e5d384f6b75f01ec79cfe8c016499551494ac1)" ]; then \
				echo "Error: Please modify amavisd-new/50-user file";                                                      \
				exit;                                                                                                      \
			fi;                                                                                                            \
			adduser clamav amavis;                                                                                         \
			adduser amavis clamav;                                                                                         \
			sed -re "s/ENABLED=0/ENABLED=1/" -i /etc/default/spamassassin;                                                 \
			sed -re "s/#@/@/g" -i /etc/amavis/conf.d/15-content_filter_mode;                                               \
			sed -re "s/#   \\\\/   \\\\/g" -i /etc/amavis/conf.d/15-content_filter_mode;                                   \
			cp $(PATH_PWD)/amavisd-new/50-user /etc/amavis/conf.d/50-user;                                                 \
			postconf -e 'content_filter = smtp-amavis:[127.0.0.1]:10024';                                                  \
			if [ -z "$$(cat /etc/postfix/master.cf | grep " Configured: configure_filtering")" ]; then                     \
				if [ -f /etc/postfix/master.cf ] && [ ! -f $(PATH_PWD)/amavisd-new/master.cf.bak ]; then                   \
					cp /etc/postfix/master.cf $(PATH_PWD)/amavisd-new/master.cf.bak;                                       \
				fi;                                                                                                        \
				rm /etc/postfix/master.cf;                                                                                 \
				touch /etc/postfix/master.cf;                                                                              \
				while IFS='' read -r line || [[ -n "$$line" ]]; do                                                         \
					printf "%s\n" "$$line" >>/etc/postfix/master.cf;                                                       \
					if [ ! -z "$$(printf "%s" "$$line" | grep "^pickup .* pickup$$")" ]; then                              \
						cat $(PATH_PWD)/amavisd-new/master.cf.pickup >>/etc/postfix/master.cf;                             \
					fi;                                                                                                    \
				done <$(PATH_PWD)/amavisd-new/master.cf.bak;                                                               \
				cat $(PATH_PWD)/amavisd-new/master.cf.EOF >>/etc/postfix/master.cf;                                        \
				printf "%s\n" "# Configured: configure_filtering" >>/etc/postfix/master.cf;                                \
			fi;                                                                                                            \
			echo "===== Done =====";                                                                                       \
			exit;                                                                                                          \
		fi;                                                                                                                \
		if [ -z "$(OS_ID)" ]; then                                                                                         \
			echo "Error: OS not supported";                                                                                \
		else                                                                                                               \
			echo "Error: $(OS_ID) OS not supported";                                                                       \
		fi;

configure_ssl:
	@	if [ $$(id -u) -ne 0 ]; then                                                                                                    \
			echo "Error: Please run as root";                                                                                           \
			exit;                                                                                                                       \
		fi;                                                                                                                             \
		if [ -z $(MYHOSTNAME) ]; then                                                                                                   \
			echo "Error: MYHOSTNAME arg is not set";                                                                                    \
			exit;                                                                                                                       \
		fi;                                                                                                                             \
		if [ ! -f $(PATH_PWD)/ssl/$(MYHOSTNAME).key ]; then                                                                             \
			echo "Error: File ssl/$(MYHOSTNAME).key not found";                                                                         \
			exit;                                                                                                                       \
		fi;                                                                                                                             \
		if [ ! -f $(PATH_PWD)/ssl/$(MYHOSTNAME).crt ]; then                                                                             \
			echo "Error: File ssl/$(MYHOSTNAME).crt not found";                                                                         \
			exit;                                                                                                                       \
		fi;                                                                                                                             \
		if [ ! -f $(PATH_PWD)/ssl/cacert.pem ]; then                                                                                    \
			echo "Warning: File ssl/cacert.pem not found";                                                                              \
		fi;                                                                                                                             \
		if [ "$(OS_ID)" = "ubuntu" ]; then                                                                                              \
			echo "===== Configure SSL =====";                                                                                           \
			echo "Info: Init";                                                                                                          \
			cp $(PATH_PWD)/ssl/$(MYHOSTNAME).key /etc/ssl/private/$(MYHOSTNAME).key;                                                    \
			cp $(PATH_PWD)/ssl/$(MYHOSTNAME).crt /etc/ssl/certs/$(MYHOSTNAME).crt;                                                      \
			if [ -f $(PATH_PWD)/ssl/cacert.pem ]; then                                                                                  \
				cp $(PATH_PWD)/ssl/cacert.pem /etc/ssl/certs/cacert.pem;                                                                \
			else                                                                                                                        \
				if [ ! -f /etc/ssl/certs/cacert.pem ]; then                                                                             \
					echo "Error: File /etc/ssl/certs/cacert.pem not found";                                                             \
					exit;                                                                                                               \
				fi;                                                                                                                     \
			fi;                                                                                                                         \
			hash=$$(openssl x509 -noout -hash -in /etc/ssl/certs/cacert.pem);                                                           \
			rm -rf /etc/ssl/certs/$$hash.0;                                                                                             \
			ln -s /etc/ssl/certs/cacert.pem /etc/ssl/certs/$$hash.0;                                                                    \
			cat /etc/ssl/certs/$(MYHOSTNAME).crt /etc/ssl/certs/cacert.pem >/etc/ssl/certs/dovecot.crt;                                 \
			echo "Info: Configure Postfix for SMTP-AUTH using SASL (Dovecot SASL)";                                                     \
			postconf -e 'smtpd_sasl_type = dovecot';                                                                                    \
			postconf -e 'smtpd_sasl_path = private/auth';                                                                               \
			postconf -e 'smtpd_sasl_local_domain =';                                                                                    \
			postconf -e 'smtpd_sasl_security_options = noanonymous';                                                                    \
			postconf -e 'broken_sasl_auth_clients = yes';                                                                               \
			postconf -e 'smtpd_sasl_auth_enable = yes';                                                                                 \
			postconf -e 'smtpd_recipient_restrictions = permit_sasl_authenticated,permit_mynetworks,reject_unauth_destination';         \
			echo "Info: Configure Postfix to provide TLS encryption for both incoming and outgoing mail";                               \
			postconf -e 'smtp_tls_security_level = may';                                                                                \
			postconf -e 'smtpd_tls_security_level = may';                                                                               \
			postconf -e 'smtp_tls_note_starttls_offer = yes';                                                                           \
			postconf -e 'smtpd_tls_key_file = /etc/ssl/private/$(MYHOSTNAME).key';                                                      \
			postconf -e 'smtpd_tls_cert_file = /etc/ssl/certs/$(MYHOSTNAME).crt';                                                       \
			postconf -e 'smtpd_tls_loglevel = 1';                                                                                       \
			postconf -e 'smtpd_tls_received_header = yes';                                                                              \
			postconf -e 'myhostname = $(MYHOSTNAME)';                                                                                   \
			postconf -e 'smtpd_tls_CAfile = /etc/ssl/certs/cacert.pem';                                                                 \
			echo "Info: Configure SASL";                                                                                                \
			if [ -z $$(cat /etc/dovecot/conf.d/10-master.conf | grep -E " Configured: configure_ssl") ]; then                           \
				if [ -f /etc/dovecot/conf.d/10-master.conf ] && [ ! -f $(PATH_PWD)/ssl/10-master.conf.bak ]; then                       \
					cp /etc/dovecot/conf.d/10-master.conf $(PATH_PWD)/ssl/10-master.conf.bak;                                           \
				fi;                                                                                                                     \
				rm -rf /etc/dovecot/conf.d/10-master.conf;                                                                              \
				touch /etc/dovecot/conf.d/10-master.conf;                                                                               \
				while IFS='' read -r line || [[ -n "$$line" ]]; do                                                                      \
					printf "%s\n" "$$line" >>/etc/dovecot/conf.d/10-master.conf;                                                        \
					if [ ! -z "$$(printf "%s" "$$line" | grep "^service auth ")" ]; then                                                \
						cat $(PATH_PWD)/ssl/10-master.conf >>/etc/dovecot/conf.d/10-master.conf;                                        \
					fi;                                                                                                                 \
				done <$(PATH_PWD)/ssl/10-master.conf.bak;                                                                               \
				printf "%s\n" "# Configured: configure_ssl" >>/etc/dovecot/conf.d/10-master.conf;                                       \
			fi;                                                                                                                         \
			if [ -z $$(cat /etc/dovecot/conf.d/10-auth.conf | grep -E " Configured: configure_ssl") ]; then                             \
				if [ -f /etc/dovecot/conf.d/10-auth.conf ] && [ ! -f $(PATH_PWD)/ssl/10-auth.conf.bak ]; then                           \
					cp /etc/dovecot/conf.d/10-auth.conf $(PATH_PWD)/ssl/10-auth.conf.bak;                                               \
				fi;                                                                                                                     \
				rm -rf /etc/dovecot/conf.d/10-auth.conf;                                                                                \
				touch /etc/dovecot/conf.d/10-auth.conf;                                                                                 \
				while IFS='' read -r line || [[ -n "$$line" ]]; do                                                                      \
					if [ ! -z "$$(printf "%s" "$$line" | grep -E "^[ ]*auth_mechanisms[ ]*=" | grep -E "=(|.* )login(| .*)$$")" ]; then \
						printf "%s login\n" "$$line" >>/etc/dovecot/conf.d/10-auth.conf;                                                \
						continue;                                                                                                       \
					fi;                                                                                                                 \
					printf "%s\n" "$$line" >>/etc/dovecot/conf.d/10-auth.conf;                                                          \
				done <$(PATH_PWD)/ssl/10-auth.conf.bak;                                                                                 \
				printf "%s\n" "# Configured: configure_ssl" >>/etc/dovecot/conf.d/10-auth.conf;                                         \
			fi;                                                                                                                         \
			echo "Info: Configure smtps";                                                                                               \
			if [ -z "$$(cat /etc/postfix/master.cf | grep " Configured: configure_ssl")" ]; then                                        \
				if [ -f /etc/postfix/master.cf ] && [ ! -f $(PATH_PWD)/ssl/master.cf.bak ]; then                                        \
					cp /etc/postfix/master.cf $(PATH_PWD)/ssl/master.cf.bak;                                                            \
				fi;                                                                                                                     \
				cat $(PATH_PWD)/ssl/master.cf >>/etc/postfix/master.cf;                                                                 \
				printf "%s\n" "# Configured: configure_filtering" >>/etc/postfix/master.cf;                                             \
			fi;                                                                                                                         \
			echo "Info: Configure Dovecot SSL";                                                                                         \
			if [ -f /etc/dovecot/conf.d/10-ssl.conf ] && [ ! -f $(PATH_PWD)/ssl/10-ssl.conf.bak ]; then                                 \
				cp /etc/dovecot/conf.d/10-ssl.conf $(PATH_PWD)/ssl/10-ssl.conf.bak;                                                     \
			fi;                                                                                                                         \
			rm -rf /etc/dovecot/conf.d/10-ssl.conf;                                                                                     \
			touch /etc/dovecot/conf.d/10-ssl.conf;                                                                                      \
			while IFS='' read -r line || [[ -n "$$line" ]]; do                                                                          \
				if [ ! -z "$$(printf "%s" "$$line" | grep "^ssl[ ]*=")" ]; then                                                         \
					printf "%s\n" "ssl = yes" >>/etc/dovecot/conf.d/10-ssl.conf;                                                        \
					continue;                                                                                                           \
				fi;                                                                                                                     \
				if [ ! -z "$$(printf "%s" "$$line" | grep "^ssl_cert[ ]*=")" ]; then                                                    \
					printf "%s\n" "ssl_cert = </etc/ssl/certs/dovecot.crt" >>/etc/dovecot/conf.d/10-ssl.conf;                           \
					continue;                                                                                                           \
				fi;                                                                                                                     \
				if [ ! -z "$$(printf "%s" "$$line" | grep "^ssl_key[ ]*=")" ]; then                                                     \
					printf "%s\n" "ssl_key = </etc/ssl/private/$(MYHOSTNAME).key" >>/etc/dovecot/conf.d/10-ssl.conf;                    \
					continue;                                                                                                           \
				fi;                                                                                                                     \
				printf "%s\n" "$$line" >>/etc/dovecot/conf.d/10-ssl.conf;                                                               \
			done <$(PATH_PWD)/ssl/10-ssl.conf.bak;                                                                                      \
			echo "===== Done =====";                                                                                                    \
			exit;                                                                                                                       \
		fi;                                                                                                                             \
		if [ -z "$(OS_ID)" ]; then                                                                                                      \
			echo "Error: OS not supported";                                                                                             \
		else                                                                                                                            \
			echo "Error: $(OS_ID) OS not supported";                                                                                    \
		fi;

start:
	@	if [ $$(id -u) -ne 0 ]; then                                                              \
			echo "Error: Please run as root";                                                     \
			exit;                                                                                 \
		fi;                                                                                       \
		if [ "$(OS_ID)" = "ubuntu" ]; then                                                        \
			if [ -z "$$(systemctl status spamassassin.service | grep "Active: active ")" ]; then  \
				echo "===== Start spamassassin.service =====";                                    \
				systemctl start spamassassin.service;                                             \
			else                                                                                  \
				echo "===== Restart spamassassin.service =====";                                  \
				systemctl restart spamassassin.service;                                           \
			fi;                                                                                   \
			if [ -z "$$(systemctl status clamav-daemon.service | grep "Active: active ")" ]; then \
				echo "===== Start clamav-daemon.service =====";                                   \
				systemctl start clamav-daemon.service;                                            \
			else                                                                                  \
				echo "===== Restart clamav-daemon.service =====";                                 \
				systemctl restart clamav-daemon.service;                                          \
			fi;                                                                                   \
			if [ -z "$$(systemctl status amavis.service | grep "Active: active ")" ]; then        \
				echo "===== Start amavis.service =====";                                          \
				systemctl start amavis.service;                                                   \
			else                                                                                  \
				echo "===== Restart amavis.service =====";                                        \
				systemctl restart amavis.service;                                                 \
			fi;                                                                                   \
			if [ -z "$$(systemctl status postfix.service | grep "Active: active ")" ]; then       \
				echo "===== Start postfix.service =====";                                         \
				systemctl start postfix.service;                                                  \
			else                                                                                  \
				echo "===== Restart postfix.service =====";                                       \
				systemctl restart postfix.service;                                                \
			fi;                                                                                   \
			if [ -z "$$(systemctl status dovecot.service | grep "Active: active ")" ]; then       \
				echo "===== Start dovecot.service =====";                                         \
				systemctl start dovecot.service;                                                  \
			else                                                                                  \
				echo "===== Restart dovecot.service =====";                                       \
				systemctl restart dovecot.service;                                                \
			fi;                                                                                   \
			echo "===== Done =====";                                                              \
			exit;                                                                                 \
		fi;                                                                                       \
		if [ -z "$(OS_ID)" ]; then                                                                \
			echo "Error: OS not supported";                                                       \
		else                                                                                      \
			echo "Error: $(OS_ID) OS not supported";                                              \
		fi;

only_squirrelmail:
	@	if [ $$(id -u) -ne 0 ]; then                                                     \
			echo "Error: Please run as root";                                            \
			exit;                                                                        \
		fi;                                                                              \
		if [ "$(OS_ID)" = "ubuntu" ]; then                                               \
			if [ "$(CMD)" = "install" ]; then                                            \
				$(PATH_PWD)/squirrelmail/install.sh || exit;                             \
				echo "===== Done =====";                                                 \
				exit;                                                                    \
			fi;                                                                          \
			if [ "$(CMD)" = "uninstall" ]; then                                          \
				$(PATH_PWD)/squirrelmail/uninstall.sh || exit;                           \
				echo "===== Done =====";                                                 \
				exit;                                                                    \
			fi;                                                                          \
			if [ "$(CMD)" = "configure" ]; then                                          \
				$(PATH_PWD)/squirrelmail/configure.sh || exit;                           \
				echo "===== Done =====";                                                 \
				exit;                                                                    \
			fi;                                                                          \
			if [ "$(CMD)" = "start" ]; then                                              \
				$(PATH_PWD)/squirrelmail/start.sh || exit;                               \
				echo "===== Done =====";                                                 \
				exit;                                                                    \
			fi;                                                                          \
			echo "Error: CMD arg must be one of {install, uninstall, configure, start}"; \
			exit;                                                                        \
		fi;                                                                              \
		if [ -z "$(OS_ID)" ]; then                                                       \
			echo "Error: OS not supported";                                              \
		else                                                                             \
			echo "Error: $(OS_ID) OS not supported";                                     \
		fi;
