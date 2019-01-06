SHELL    := /bin/bash
PATH_PWD := $(shell pwd)
OS_ID    := $(shell cat /etc/os-release | grep "^ID=" | cut -c 4-)

help:
	@	echo "- Show help:                    $$ make help"
	@	echo "- Install dependencies:     (1) $$ sudo make install"
	@	echo "- Uninstall dependencies:       $$ sudo make uninstall"
	@	echo "- Configure postfix:        (2) $$ sudo make configure_postfix"
	@	echo "- Configure squirrelmail:   (3) $$ sudo make configure_squirrelmail"
	@	echo "- Configure mail filtering: (4) $$ sudo make configure_filtering"
	@	echo "- Start service:            (5) $$ sudo make start"
	@	echo "RECOMMEND: (1) -> (2) -> (3) -> (4) -> (5)"

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
			$(PATH_PWD)/squirrelmail/install.sh || exit;                        \
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
			$(PATH_PWD)/squirrelmail/uninstall.sh || exit;                                          \
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

configure_squirrelmail:
	@	if [ $$(id -u) -ne 0 ]; then                       \
			echo "Error: Please run as root";              \
			exit;                                          \
		fi;                                                \
		if [ "$(OS_ID)" = "ubuntu" ]; then                 \
			$(PATH_PWD)/squirrelmail/configure.sh || exit; \
			echo "===== Done =====";                       \
			exit;                                          \
		fi;                                                \
		if [ -z "$(OS_ID)" ]; then                         \
			echo "Error: OS not supported";                \
		else                                               \
			echo "Error: $(OS_ID) OS not supported";       \
		fi;

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
			if [ -f /etc/postfix/master.cf ] && [ ! -f $(PATH_PWD)/amavisd-new/master.cfi.bak ]; then                      \
				cp /etc/postfix/master.cf $(PATH_PWD)/amavisd-new/master.cfi.bak;                                          \
			fi;                                                                                                            \
			touch $(PATH_PWD)/amavisd-new/master.cfi;                                                                      \
			while read line; do                                                                                            \
				echo $$line >>$(PATH_PWD)/amavisd-new/master.cfi;                                                          \
				if [ ! -z "$$(echo $$line | grep "^pickup .*$$")" ];                                                       \
					cat $(PATH_PWD)/amavisd-new/master.cfi.pickup >>$(PATH_PWD)/amavisd-new/master.cfi;                    \
				fi;                                                                                                        \
			done <$(PATH_PWD)/amavisd-new/master.cfi.bak;                                                                  \
			cat $(PATH_PWD)/amavisd-new/master.cfi.EOF >>$(PATH_PWD)/amavisd-new/master.cfi;                               \
			mv $(PATH_PWD)/amavisd-new/master.cfi /etc/postfix/master.cf;                                                  \
			echo "===== Done =====";                                                                                       \
			exit;                                                                                                          \
		fi;                                                                                                                \
		if [ -z "$(OS_ID)" ]; then                                                                                         \
			echo "Error: OS not supported";                                                                                \
		else                                                                                                               \
			echo "Error: $(OS_ID) OS not supported";                                                                       \
		fi;

start:
	@	if [ $$(id -u) -ne 0 ]; then                                                              \
			echo "Error: Please run as root";                                                     \
			exit;                                                                                 \
		fi;                                                                                       \
		if [ "$(OS_ID)" = "ubuntu" ]; then                                                        \
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
			$(PATH_PWD)/squirrelmail/start.sh || exit;                                            \
			if [ -z "$$(systemctl status spamassassin.service | grep "Active: active ")" ]; then  \
				echo "===== Start spamassassin.service =====";                                    \
				systemctl start spamassassin.service;                                             \
			else                                                                                  \
				echo "===== Restart spamassassin.service =====";                                  \
				systemctl restart spamassassin.service;                                           \
			fi;                                                                                   \
			if [ -z "$$(systemctl status amavis.service | grep "Active: active ")" ]; then        \
				echo "===== Start amavis.service =====";                                          \
				systemctl start amavis.service;                                                   \
			else                                                                                  \
				echo "===== Restart amavis.service =====";                                        \
				systemctl restart amavis.service;                                                 \
			fi;                                                                                   \
			if [ -z "$$(systemctl status clamav-daemon.service | grep "Active: active ")" ]; then \
				echo "===== Start clamav-daemon.service =====";                                   \
				systemctl start clamav-daemon.service;                                            \
			else                                                                                  \
				echo "===== Restart clamav-daemon.service =====";                                 \
				systemctl restart clamav-daemon.service;                                          \
			fi;                                                                                   \
			echo "===== Done =====";                                                              \
			exit;                                                                                 \
		fi;                                                                                       \
		if [ -z "$(OS_ID)" ]; then                                                                \
			echo "Error: OS not supported";                                                       \
		else                                                                                      \
			echo "Error: $(OS_ID) OS not supported";                                              \
		fi;
