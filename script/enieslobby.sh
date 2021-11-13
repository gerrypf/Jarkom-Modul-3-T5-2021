echo "nameserver 192.168.122.1" > /etc/resolv.conf
apt-get update
apt-get install bind9 -y
# nomor 2 - 7
echo "
options {
        directory \"/var/cache/bind\";
        forwarders {
                8.8.8.8;
                8.8.8.4;
        };
        // dnssec-validation auto;
        allow-query { any; };
        auth-nxdomain no;    # conform to RFC1035
        listen-on-v6 { any; };
};
" > /etc/bind/named.conf.options
service bind9 restart

# nomor 8
echo "
zone \"jualbelikapal.t05.com\" {
        type master;
        file \"/etc/bind/jarkom/jualbelikapal.t05.com\";
};
" > /etc/bind/named.conf.local

mkdir /etc/bind/jarkom/ 

echo "
\$TTL    604800
@       IN      SOA     jualbelikapal.t05.com. root.jualbelikapal.t05.com. (
                        2021100401      ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      jualbelikapal.t05.com.
@       IN      A       10.44.2.3
" > /etc/bind/jarkom/jualbelikapal.t05.com

service bind9 restart
# nomor 11
echo "
zone \"jualbelikapal.t05.com\" {
        type master;
        file \"/etc/bind/jarkom/jualbelikapal.t05.com\";
};
zone \"super.franky.t05.com\" {
        type master;
        file \"/etc/bind/kaizoku/super.franky.t05.com\";
};
" > /etc/bind/named.conf.local

mkdir /etc/bind/kaizoku/
echo "
\$TTL    604800
@       IN      SOA     super.franky.t05.com. root.super.franky.t05.com. (
                        2021100401      ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      super.franky.t05.com.
@       IN      A       10.44.3.69
" > /etc/bind/kaizoku/super.franky.t05.com

service bind9 restart
