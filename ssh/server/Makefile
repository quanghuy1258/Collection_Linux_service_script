# Using Makefile instead of bash script

test_code:
	@	$(eval OS_ID := $(shell cat /etc/os-release | grep "^ID=" | cut -c 4-))
	@	echo "id=$(OS_ID)"
	@	if [ "$(OS_ID)" = "ubuntu" ]; then \
			echo "ubuntu"; \
		fi

# $ make
all:
	@	if [ $$(id -u) -ne 0 ]; then       \
			echo "Error: Please run as root"; \
			exit;                             \
		fi
	@	$(eval OS_ID := $(shell cat /etc/os-release | grep "^ID=" | cut -c 4-))
	@	if [ "$(OS_ID)" = "ubuntu" ]; then \
			echo "doing something with ubuntu"; \
		fi

# $ make list_targets
# List all possible targets
list_targets:
	@	echo "all"
	@	echo "list_targets"

