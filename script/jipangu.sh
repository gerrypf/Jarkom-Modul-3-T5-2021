echo "nameserver 192.168.122.1" > /etc/resolv.conf
apt-get update
apt-get install isc-dhcp-server -y

echo "
# On what interfaces should the DHCP server (dhcpd) serve DHCP requests?
#       Separate multiple interfaces with spaces, e.g. \"eth0 eth1\".
INTERFACES=\"eth0\"
" > /etc/default/isc-dhcp-server

echo " 
subnet 10.44.2.0 netmask 255.255.255.0 {
}
subnet 10.44.1.0 netmask 255.255.255.0 {
    range  10.44.1.20 10.44.1.99;
    range  10.44.1.150 10.44.1.169;
    option routers 10.44.1.1;
    option broadcast-address 10.44.1.255;
    option domain-name-servers 10.44.2.2;
    default-lease-time 360;
    max-lease-time 7200;
}
subnet 10.44.3.0 netmask 255.255.255.0 {
    range  10.44.3.30 10.44.3.50;
    option routers 10.44.3.1;
    option broadcast-address 10.44.3.255;
    option domain-name-servers 10.44.2.2;
    default-lease-time 720;
    max-lease-time 7200;
}
host Skypie {
    hardware ethernet be:c0:ff:37:bb:09;
    fixed-address 10.44.3.69;
}
" >  /etc/dhcp/dhcpd.conf
service isc-dhcp-server restart
