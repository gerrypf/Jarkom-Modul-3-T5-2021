echo "nameserver 192.168.122.1" > /etc/resolv.conf
apt-get update
apt-get install libapache2-mod-php7.0 -y
apt-get install squid -y

# nomor 7 - 8
echo "
http_port 5000
visible_hostname jualbelikapal.t05.com
#http_access allow all
" > /etc/squid/squid.conf

service squid start

# nomor 9
htpasswd -cbm /etc/squid/passwd luffybelikapalt05 luffy_t05
htpasswd -bm /etc/squid/passwd zorobelikapalt05 zoro_t05
echo "
http_port 5000
visible_hostname jualbelikapal.t05.com
#http_access allow all
auth_param basic program /usr/lib/squid/basic_ncsa_auth /etc/squid/passwd
auth_param basic children 5
auth_param basic realm Proxy
auth_param basic credentialsttl 2 hours
auth_param basic casesensitive on
acl USERS proxy_auth REQUIRED
http_access deny all
" > /etc/squid/squid.conf

# nomor 10

echo "
acl AVAILABLE_WORKING time MTWH 07:00-11:00
acl AVAILABLE_WORKING time TWHF 17:00-23:59
acl AVAILABLE_WORKING time WHFA 00:00-03:00
" >/etc/squid/acl.conf

echo "
include /etc/squid/acl.conf
http_port 5000
visible_hostname jualbelikapal.t05.com
#http_access allow all
auth_param basic program /usr/lib/squid/basic_ncsa_auth /etc/squid/passwd
auth_param basic children 5
auth_param basic realm Proxy
auth_param basic credentialsttl 2 hours
auth_param basic casesensitive on
acl USERS proxy_auth REQUIRED
http_access allow USERS AVAILABLE_WORKING
http_access deny all
" > /etc/squid/squid.conf

service squid restart

# nomor 11
echo "
include /etc/squid/acl.conf
http_port 5000
visible_hostname jualbelikapal.t05.com
#http_access allow all
auth_param basic program /usr/lib/squid/basic_ncsa_auth /etc/squid/passwd
auth_param basic children 5
auth_param basic realm Proxy
auth_param basic credentialsttl 2 hours
auth_param basic casesensitive on
acl USERS proxy_auth REQUIRED
#client acl for the lan
acl lan src 10.44.3.0/24 10.44.1.0/24
#to deny \"google.com\"
acl badsites dstdomain .google.com
#Deny with redirect to Google SafeSearch for lan
deny_info http://super.franky.t05.com lan
#Deny badsites to lan
http_reply_access deny badsites lan
http_access allow USERS AVAILABLE_WORKING
http_access deny all
dns_nameservers 10.44.2.2
" > /etc/squid/squid.conf

# nomor 12

echo "
include /etc/squid/acl.conf
http_port 5000
visible_hostname jualbelikapal.t05.com
#http_access allow all
auth_param basic program /usr/lib/squid/basic_ncsa_auth /etc/squid/passwd
auth_param basic children 5
auth_param basic realm Proxy
auth_param basic credentialsttl 2 hours
auth_param basic casesensitive on
acl USERS proxy_auth REQUIRED
#client acl for the lan
acl lan src 10.44.3.0/24 10.44.1.0/24
#to deny \"google.com\"
acl badsites dstdomain .google.com
#Deny with redirect to Google SafeSearch for lan
deny_info http://super.franky.t05.com lan
#Deny badsites to lan
http_reply_access deny badsites lan
http_access allow USERS AVAILABLE_WORKING
dns_nameservers 10.44.2.2
acl multimedia url_regex -i \.png$ \.jpg$
acl bar proxy_auth luffybelikapalt05
delay_pools 1
delay_class 1 1
delay_parameters 1 1250/3200
delay_access 1 allow multimedia bar
delay_access 1 deny ALL
http_access deny ALL
" > /etc/squid/squid.conf

service squid restart
