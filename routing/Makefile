SHELL    := /bin/bash
PATH_PWD := $(shell pwd)
OS_ID    := $(shell cat /etc/os-release | grep "^ID=" | cut -c 4-)

help:
	@	echo "- Show help:     $$ make help"
	@	echo "- Routing:   (1) $$ sudo make routing IFACE={string}"
	@	echo "RECOMMEND: (1)"

routing:
	@	if [ $$(id -u) -ne 0 ]; then                                                        \
			echo "Error: Please run as root";                                               \
			exit;                                                                           \
		fi;                                                                                 \
		if [ -z "$(IFACE)" ]; then                                                          \
			echo "Error: IFACE arg is not set";                                             \
			exit;                                                                           \
		fi;                                                                                 \
		if [ "$(OS_ID)" = "ubuntu" ]; then                                                  \
			echo 1 >/proc/sys/net/ipv4/ip_forward;                                          \
			iptables -t nat -A POSTROUTING -o $(IFACE) -j MASQUERADE;                       \
			iptables -A FORWARD -o $(IFACE) -j ACCEPT;                                      \
			iptables -A FORWARD -m state --state ESTABLISHED,RELATED -i $(IFACE) -j ACCEPT; \
			echo "===== Done =====";                                                        \
			exit;                                                                           \
		fi;                                                                                 \
		if [ -z "$(OS_ID)" ]; then                                                          \
			echo "Error: OS not supported";                                                 \
		else                                                                                \
			echo "Error: $(OS_ID) OS not supported";                                        \
		fi;
