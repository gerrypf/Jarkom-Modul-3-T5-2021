apt-get update
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 10.44.0.0/16
apt-get install isc-dhcp-relay -y

# nomor 2 - 7

echo "
# What servers should the DHCP relay forward requests to?
SERVERS=\"10.44.2.4\"
# On what interfaces should the DHCP relay (dhrelay) serve DHCP requests?
INTERFACES=\"eth1 eth3 eth2\"
# Additional options that are passed to the DHCP relay daemon?
OPTIONS=\"\"
" > /etc/default/isc-dhcp-relay
service isc-dhcp-relay restart
