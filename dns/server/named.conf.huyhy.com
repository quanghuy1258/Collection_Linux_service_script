zone "huyhy.com" {
	type master;
	file "/etc/bind/db.huyhy.com";
};
