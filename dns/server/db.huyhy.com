$TTL	604800
@	IN	SOA	huyhy.com. root.huyhy.com. (
			      2		; Serial
			 604800		; Refresh
			  86400		; Retry
			2419200		; Expire
			 604800 )	; Negative Cache TTL
;
	IN	NS	ns.huyhy.com.
	IN	MX	1	mail.huyhy.com.
ns	IN	A	192.168.231.2
www	IN	A	172.16.231.251
ftp	IN	A	172.16.231.251
mail	IN	A	172.16.231.252
proxy	IN	A	192.168.231.1
