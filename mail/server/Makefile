# Using Makefile instead of bash script

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
			if [ -z "$$(apt list --installed | grep "^postfix/")" ]; then                                 \
				echo "Installing postfix ...";                                                            \
				sudo apt-get -y install postfix;                                                          \
			fi;                                                                                           \
			if [ -z "$$(apt list --installed | grep "^dovecot-core/")" ]; then                            \
				echo "Installing dovecot-core ...";                                                       \
				sudo apt-get -y install dovecot-core;                                                     \
			fi;                                                                                           \
			if [ -z "$$(apt list --installed | grep "^squirrelmail/")" ]; then                            \
				echo "Installing squirrelmail ...";                                                       \
				sudo apt-get -y install squirrelmail;                                                     \
			fi;                                                                                           \
			if [ -z "$$(apt list --installed | grep "^amavisd-new/")" ]; then                             \
				echo "Installing amavisd-new ...";                                                        \
				sudo apt-get -y install amavisd-new;                                                      \
			fi;                                                                                           \
			if [ -z "$$(apt list --installed | grep "^spamassassin/")" ]; then                            \
				echo "Installing spamassassin ...";                                                       \
				sudo apt-get -y install spamassassin;                                                     \
			fi;                                                                                           \
			if [ -z "$$(apt list --installed | grep "^clamav-daemon/")" ]; then                           \
				echo "Installing clamav-daemon ...";                                                      \
				sudo apt-get -y install clamav-daemon;                                                    \
			fi;                                                                                           \
			exit;                                                                                         \
		fi;                                                                                               \
		if [ -z "$$OS_ID" ]; then                                                                         \
			echo "Error: OS not supported";                                                               \
		else                                                                                              \
			echo "Error: $$OS_ID OS not supported";                                                       \
		fi;
