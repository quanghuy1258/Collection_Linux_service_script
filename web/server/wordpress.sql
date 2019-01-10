CREATE DATABASE database_name_here;
GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,ALTER
ON database_name_here.*
TO username_here@localhost
IDENTIFIED BY 'password_here';
FLUSH PRIVILEGES;
