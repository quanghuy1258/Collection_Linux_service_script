SHELL    := /bin/bash
PATH_PWD := $(shell pwd)
OS_ID    := $(shell cat /etc/os-release | grep "^ID=" | cut -c 4-)

help:
	@	echo "- Show help:                  $$ make help"
	@	echo "- Install dependencies:   (1) $$ sudo make install"
	@	echo "- Uninstall dependencies:     $$ sudo make uninstall"
	@	echo "- Configure:              (2) $$ sudo make configure"
	@	echo "- Start:                  (3) $$ sudo make start IFACE={string}"
	@	echo "RECOMMEND: (1) -> (2) -> (3)"

install:
	@	if [ $$(id -u) -ne 0 ]; then                                    \
			echo "Error: Please run as root";                           \
			exit;                                                       \
		fi;                                                             \
		if [ "$(OS_ID)" = "ubuntu" ]; then                              \
			if [ -z "$$(apt list --installed | grep "^squid/")" ]; then \
				echo "===== Install squid =====";                       \
				apt-get -y install squid;                               \
			fi;                                                         \
			echo "===== Done =====";                                    \
			exit;                                                       \
		fi;                                                             \
		if [ -z "$(OS_ID)" ]; then                                      \
			echo "Error: OS not supported";                             \
		else                                                            \
			echo "Error: $(OS_ID) OS not supported";                    \
		fi;

uninstall:
	@	if [ $$(id -u) -ne 0 ]; then                                                        \
			echo "Error: Please run as root";                                               \
			exit;                                                                           \
		fi;                                                                                 \
		if [ "$(OS_ID)" = "ubuntu" ]; then                                                  \
			if [ ! -z "$$(systemctl status squid.service | grep "Active: active ")" ]; then \
				echo "===== Stop squid.service =====";                                      \
				systemctl stop squid.service;                                               \
			fi;                                                                             \
			if [ ! -z "$$(apt list --installed | grep "^squid/")" ]; then                   \
				echo "===== Uninstall squid =====";                                         \
				apt-get -y purge squid;                                                     \
			fi;                                                                             \
			echo "===== Done =====";                                                        \
			exit;                                                                           \
		fi;                                                                                 \
		if [ -z "$(OS_ID)" ]; then                                                          \
			echo "Error: OS not supported";                                                 \
		else                                                                                \
			echo "Error: $(OS_ID) OS not supported";                                        \
		fi;

configure:
	@	if [ $$(id -u) -ne 0 ]; then                                                                                               \
			echo "Error: Please run as root";                                                                                      \
			exit;                                                                                                                  \
		fi;                                                                                                                        \
		if [ ! -f "$(PATH_PWD)/bad-http.acl" ]; then                                                                               \
			echo "Error: File bad-http.acl is not found";                                                                          \
			exit;                                                                                                                  \
		fi;                                                                                                                        \
		if [ -z "$$(cat $(PATH_PWD)/bad-http.acl)" ]; then                                                                         \
			echo "Warning: File bad-http.acl is empty";                                                                            \
			read -r -p "Continue? [y/N] " response;                                                                                \
			if [ -z "$$(echo $$response | grep -E "^([yY][eE][sS]|y)$$")" ]; then                                                  \
				exit;                                                                                                              \
			fi;                                                                                                                    \
		fi;                                                                                                                        \
		if [ ! -f "$(PATH_PWD)/bad-https.acl" ]; then                                                                              \
			echo "Error: File bad-https.acl is not found";                                                                         \
			exit;                                                                                                                  \
		fi;                                                                                                                        \
		if [ -z "$$(cat $(PATH_PWD)/bad-https.acl)" ]; then                                                                        \
			echo "Warning: File bad-https.acl is empty";                                                                           \
			read -r -p "Continue? [y/N] " response;                                                                                \
			if [ -z "$$(echo $$response | grep -E "^([yY][eE][sS]|y)$$")" ]; then                                                  \
				exit;                                                                                                              \
			fi;                                                                                                                    \
		fi;                                                                                                                        \
		if [ "$(OS_ID)" = "ubuntu" ]; then                                                                                         \
			etc_dir=/etc/squid;                                                                                                    \
			if [ -f "$${etc_dir}/bad-http.acl" ] && [ ! -f "$(PATH_PWD)/bad-http.acl.bak" ]; then                                  \
				cp $${etc_dir}/bad-http.acl $(PATH_PWD)/bad-http.acl.bak;                                                          \
			fi;                                                                                                                    \
			if [ -f "$(PATH_PWD)/bad-http.acl.bak" ]; then                                                                         \
				cp $(PATH_PWD)/bad-http.acl.bak $${etc_dir}/bad-http.acl;                                                          \
			else                                                                                                                   \
				touch $(PATH_PWD)/bad-http.acl.bak;                                                                                \
			fi;                                                                                                                    \
			cat $(PATH_PWD)/bad-http.acl >>$${etc_dir}/bad-http.acl;                                                               \
			if [ -f "$${etc_dir}/bad-https.acl" ] && [ ! -f "$(PATH_PWD)/bad-https.acl.bak" ]; then                                \
				cp $${etc_dir}/bad-https.acl $(PATH_PWD)/bad-https.acl.bak;                                                        \
			fi;                                                                                                                    \
			if [ -f "$(PATH_PWD)/bad-https.acl.bak" ]; then                                                                        \
				cp $(PATH_PWD)/bad-https.acl.bak $${etc_dir}/bad-https.acl;                                                        \
			else                                                                                                                   \
				touch $(PATH_PWD)/bad-https.acl.bak;                                                                               \
			fi;                                                                                                                    \
			cat $(PATH_PWD)/bad-https.acl >>$${etc_dir}/bad-https.acl;                                                             \
			if [ ! -f "$(PATH_PWD)/squid.conf.bak" ]; then                                                                         \
				cp $${etc_dir}/squid.conf $(PATH_PWD)/squid.conf.bak;                                                              \
			fi;                                                                                                                    \
			cp $(PATH_PWD)/squid.conf.bak $${etc_dir}/squid.conf;                                                                  \
			if [ -z "$$(cat $${etc_dir}/squid.conf | grep "acl bad_https ssl::server_name \"$${etc_dir}/bad-https.acl\"")" ]; then \
				echo "acl bad_https ssl::server_name \"$${etc_dir}/bad-https.acl\"" >temp;                                         \
				cat $${etc_dir}/squid.conf >>temp;                                                                                 \
				mv temp $${etc_dir}/squid.conf;                                                                                    \
			fi;                                                                                                                    \
			if [ -z "$$(cat $${etc_dir}/squid.conf | grep "acl bad_http dstdomain \"$${etc_dir}/bad-http.acl\"")" ]; then          \
				echo "acl bad_http dstdomain \"$${etc_dir}/bad-http.acl\"" >temp;                                                  \
				cat $${etc_dir}/squid.conf >>temp;                                                                                 \
				mv temp $${etc_dir}/squid.conf;                                                                                    \
			fi;                                                                                                                    \
			sed -i "/^http_access deny all/c\http_access allow all" $${etc_dir}/squid.conf;                                        \
			if [ -z "$$(cat $${etc_dir}/squid.conf | grep "^http_access allow all")" ]; then                                       \
				lastline=$$(cat $${etc_dir}/squid.conf | grep "^http_access " | tail -n 1);                                        \
				sed -i "/$${lastline}/a\http_access allow all" $${etc_dir}/squid.conf;                                             \
			fi;                                                                                                                    \
			if [ -z "$$(cat $${etc_dir}/squid.conf | grep "^http_access deny bad_http")" ]; then                                   \
				sed -i "/^http_access allow all/i\http_access deny bad_http" $${etc_dir}/squid.conf;                               \
			fi;                                                                                                                    \
			if [ ! -z "$$(cat $${etc_dir}/squid.conf | grep "^http_port 3128$$")" ]; then                                          \
				sed -i "/^http_port 3128$$/c\http_port 3128 intercept" $${etc_dir}/squid.conf;                                     \
			fi;                                                                                                                    \
			echo "===== Done =====";                                                                                               \
			exit;                                                                                                                  \
		fi;                                                                                                                        \
		if [ -z "$(OS_ID)" ]; then                                                                                                 \
			echo "Error: OS not supported";                                                                                        \
		else                                                                                                                       \
			echo "Error: $(OS_ID) OS not supported";                                                                               \
		fi;

start:
	@	if [ $$(id -u) -ne 0 ]; then                                                                 \
			echo "Error: Please run as root";                                                        \
			exit;                                                                                    \
		fi;                                                                                          \
		if [ -z "$(IFACE)" ]; then                                                                   \
			echo "Error: IFACE arg is not set";                                                      \
			exit;                                                                                    \
		fi;                                                                                          \
		if [ "$(OS_ID)" = "ubuntu" ]; then                                                           \
			echo 1 >/proc/sys/net/ipv4/ip_forward;                                                   \
			iptables -t nat -A PREROUTING -i $(IFACE) -p tcp --dport 80  -j REDIRECT --to-port 3128; \
			if [ -z "$$(systemctl status squid.service | grep "Active: active ")" ]; then            \
				echo "===== Start squid.service =====";                                              \
				systemctl start squid.service;                                                       \
			else                                                                                     \
				echo "===== Restart squid.service =====";                                            \
				systemctl restart squid.service;                                                     \
			fi;                                                                                      \
			echo "===== Done =====";                                                                 \
			exit;                                                                                    \
		fi;                                                                                          \
		if [ -z "$(OS_ID)" ]; then                                                                   \
			echo "Error: OS not supported";                                                          \
		else                                                                                         \
			echo "Error: $(OS_ID) OS not supported";                                                 \
		fi;
