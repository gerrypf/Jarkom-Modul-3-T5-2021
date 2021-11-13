# Jarkom-Modul-3-T5-2021

Oleh :
1. Shavica Ihya Q A L    (05311940000013)
2. Gerry Putra Fresnando (05311940000031)
3. Mohammad Ibadul Haqqi (05311940000037)

---
Luffy yang sudah menjadi Raja Bajak Laut ingin mengembangkan daerah kekuasaannya dengan membuat peta seperti berikut:

![image](https://user-images.githubusercontent.com/73151831/141610415-506399df-ada8-4330-9dec-329013888e14.png)

## Soal 1 dan 2
Luffy bersama Zoro berencana membuat peta tersebut dengan kriteria EniesLobby sebagai DNS Server, Jipangu sebagai DHCP Server, Water7 sebagai Proxy Server (1) dan Foosha sebagai DHCP Relay (2). Luffy dan Zoro menyusun peta tersebut dengan hati-hati dan teliti.

### Jawaban
- Membuat Topologi

![image](https://user-images.githubusercontent.com/61973814/141613011-f99a1643-c0eb-4282-8f50-a05f41e9dc7a.png)

***EniesLobby -> DNS Server***
- EniesLobby sebagai DNS Server sehingga perlu melakukan install bind9
```
echo "nameserver 192.168.122.1" > /etc/resolv.conf
apt-get update
apt-get install bind9 -y
```

- dan untuk konfigurasinya seperti berikut

![messageImage_1636793434226](https://user-images.githubusercontent.com/61973814/141612705-9a203647-7950-45f8-ba5a-d63f808dc5c7.jpg)



***Skypie -> Web Server***
Skypea sebagai Web server sehingga perlu melakukan download apache
```
apt-get install apache2 -y
service apache2 start
apt-get install php -y
apt-get install libapache2-mod-php7.0 -y
apt-get install ca-certificates openssl -y
```

- untuk CLient Skypie yang akan mendaptkan alamat yang tetap yaitu 10.45.3.69 dengan konfigurasi seabagi berikut

![messageImage_1636793671122](https://user-images.githubusercontent.com/61973814/141612739-3db091ed-6812-4b6b-b0e4-90a0c1d77c7d.jpg)


***Foosha -> DHCP Relay***
Fosha sebagai DHCP Relay sehingga perlu melakukan install isc-dhcp-relay
```
apt-get update
apt-get install isc-dhcp-relay -y
```

- untuk konfigurasi Foosha sebagai berikut

![messageImage_1636793529813](https://user-images.githubusercontent.com/61973814/141612784-6dad8f86-4e71-4986-bb59-523a81449a57.jpg)
![messageImage_1636793542724](https://user-images.githubusercontent.com/61973814/141612919-dc83af40-b779-4aa4-9432-b23443a2b9ff.jpg)

***Water7 -> Proxy Server***
Water7 Sebagai Proxy server sehingga perlu melakukan install squid
```
echo "nameserver 192.168.122.1" > /etc/resolv.conf
apt-get update
apt-get install libapache2-mod-php7.0 -y
apt-get install squid -y
```

- untuk konfigurasi `Water7` sebagai berikut
![image](https://user-images.githubusercontent.com/61973814/141612854-33f47685-30cc-4e1b-a380-2759f8f6af99.png)

***Jipangu -> DHCP Server***
```
echo "nameserver 192.168.122.1" > /etc/resolv.conf
apt-get update
apt-get install isc-dhcp-server -y
```

- untuk konfigurasinya `Jipangu` sebagai berikut

![messageImage_1636794082852](https://user-images.githubusercontent.com/61973814/141612932-e8d9bd03-e969-49fb-8251-5876dde8aafa.jpg)

- Untuk Setiap Client yaitu Longuetown, Alabasta,TottoLand menggunakan konfigurasi sebagai berikut untuk penerapan DHCP

![image](https://user-images.githubusercontent.com/61973814/141612972-71412975-39e0-42ad-a231-02501b5c56ba.png)


## Soal 3
Semua client yang ada HARUS menggunakan konfigurasi IP dari DHCP Server. Client yang melalui Switch1 mendapatkan range IP dari [prefix IP].1.20 - [prefix IP].1.99 dan [prefix IP].1.150 - [prefix IP].1.169 (3)

### Jawaban

Lakukan konfigurasi pada `Foosha` dengan melakukan edit file `/etc/default/isc-dhcp-relay` dengan konfigurasi berikut
```
# Defaults for isc-dhcp-relay initscript
# sourced by /etc/init.d/isc-dhcp-relay
# installed at /etc/default/isc-dhcp-relay by the maintainer scripts

#
# This is a POSIX shell fragment
#

# What servers should the DHCP relay forward requests to?
SERVERS="10.44.2.4"

# On what interfaces should the DHCP relay (dhrelay) serve DHCP requests?
INTERFACES="eth1 eth3 eth2"

# Additional options that are passed to the DHCP relay daemon?
OPTIONS=""
```

- Lalu Konfigurasi DHCP Server pada Jipangu

Membuat Jipangu menjadi DHCP Server. Karena Jipangu Terhubung dengan Fosha melalui eth0 sehingga lakukan konfigurasi pada file `/etc/default/isc-dhcp-server` sebagai berikut:
```
# Defaults for isc-dhcp-server initscript
# sourced by /etc/init.d/isc-dhcp-server
# installed at /etc/default/isc-dhcp-server by the maintainer scripts

#
# This is a POSIX shell fragment
#

# Path to dhcpd's config file (default: /etc/dhcp/dhcpd.conf).
#DHCPD_CONF=/etc/dhcp/dhcpd.conf

# Path to dhcpd's PID file (default: /var/run/dhcpd.pid).
#DHCPD_PID=/var/run/dhcpd.pid

# Additional options to start dhcpd with.
#       Don't use options -cf or -pf here; use DHCPD_CONF/ DHCPD_PID instead
#OPTIONS=""

# On what interfaces should the DHCP server (dhcpd) serve DHCP requests?
#       Separate multiple interfaces with spaces, e.g. "eth0 eth1".
INTERFACES="eth0"
```

Lakukan restart DHCP server dengan `service isc-dhcp-server restart` Setelah itu lakukan konfigurasi untuk rentang IP yang akan diberikan pada file `/etc/dhcp/dhcpd.conf` dengan cara
```
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
```

## Soal 4
Client yang melalui Switch3 mendapatkan range IP dari [prefix IP].3.30 - [prefix IP].3.50 (4)

### Jawaban
Lakukan konfigurasi untuk rentang IP yang akan diberikan pada file /`etc/dhcp/dhcpd.conf` dengan cara menambahkan konfigurasi berikut ini
```
subnet 10.44.3.0 netmask 255.255.255.0 {
    range  10.44.3.30 10.44.3.50;
    option routers 10.44.3.1;
    option broadcast-address 10.44.3.255;
    option domain-name-servers 10.44.2.2;
    default-lease-time 720;
    max-lease-time 7200;
}
```
- Dengan begitu kita telah menentukan ip range dengan menambahkan range `10.44.3.30` `10.44.3.50` pada subnet interface `switch3` yang terhubung ke fosha pada eth3

## Soal 5
Client mendapatkan DNS dari EniesLobby dan client dapat terhubung dengan internet melalui DNS tersebut. (5)

### Jawaban
- Untuk client mendapatkan DNS dari EniesLobby diperlukan konfigurasi pada file `/etc/dhcp/dhcpd.conf` dengan option domain-name-servers `10.44.2.2`
- Supaya semua client dapat terhubung internet pada `EniesLobby` diberikan konfigurasi pada `file /etc/bind/named.conf.options` dengan
```
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
```

### Testing
Dengan mengkonfigurasi DHCP server dan DHCP Relay seleuruh Client yang berada pada subnet interface switch 1 dan switch 3 akan otomatis mendapatkan IP pada rentang yang telah dikonfigurasi. Untuk contohnya adalah sebagai berikut:

Alabasta

![image](https://user-images.githubusercontent.com/61973814/141630159-d4d38e8a-a49d-463d-a92b-186fc996a31d.png)

- Testing connect ke internet

    ![image](https://user-images.githubusercontent.com/61973814/141633672-82ceb4c4-38da-4fd4-a5ef-83641f919f16.png)

Skypie

![image](https://user-images.githubusercontent.com/61973814/141630454-2fd5b108-abb8-4d60-a87c-1f9a4ac22833.png)

- Testing connect ke internet

    ![image](https://user-images.githubusercontent.com/61973814/141634166-de7cf4d8-5f2a-478b-a441-be1532400f55.png)

Loguetown

![image](https://user-images.githubusercontent.com/61973814/141630687-5a06e2e8-2fbd-4cf3-9bb6-f888e7b41fe1.png)

- Testing connect ke internet

    ![image](https://user-images.githubusercontent.com/61973814/141632393-a923b68d-904b-488c-8185-5783cb90213b.png)

TottoLand

![image](https://user-images.githubusercontent.com/61973814/141632818-80f5be26-7c64-47b2-8776-2e9a0fa6133d.png)

- Testing connect ke internet

    ![image](https://user-images.githubusercontent.com/61973814/141633182-e19910bc-4d8b-4a62-8ab7-798a928ebfad.png)


## Soal 6
Lama waktu DHCP server meminjamkan alamat IP kepada Client yang melalui Switch1 selama 6 menit sedangkan pada client yang melalui Switch3 selama 12 menit. Dengan waktu maksimal yang dialokasikan untuk peminjaman alamat IP selama 120 menit. (6)

### Jawaban

Pada subnet interface switch 1 dan 3 ditambahkan konfigurasi berikut pada file `/etc/dhcp/dhcpd.conf` pada `Jipangu`
```
Subnet 10.44.1.0 netmask 255.255.255.0 {
    range 10.44.1.20 10.44.1.99;
    range 10.44.1.150 10.44.1.169;
    option routers 10.44.1.1;
    option broadcast-address 10.44.1.255;
    option domain-name-servers 10.44.2.2;
    default-lease-time 360;
    max-lease-time 7200;
}


subnet 10.44.3.0 netmask 255.255.255.0 {
    range 10.44.3.30 10.44.3.50;
    option routers 10.44.3.1;
    option broadcast-address 10.44.3.255;
    option domain-name-servers 10.44.2.2;
    default-lease-time 720;
    max-lease-time 7200;
}
```

Testing
- sehabis itu kita stop interface switch 1 dan start kembali, begitu pula pada interface switch 2

![image](https://user-images.githubusercontent.com/61973814/141637925-fc25d486-f835-486d-9aa6-6add12725d67.png)
- pada gambar diatas, yaitu interface switch1 menerangkan ip nya yang sudah kita setting range dan waktunya.


![image](https://user-images.githubusercontent.com/61973814/141638345-388365de-916e-4469-acad-ab5173a7da7d.png)
- Begitu pula pada interface switch2

## Soal 7
Luffy dan Zoro berencana menjadikan Skypie sebagai server untuk jual beli kapal yang dimilikinya dengan alamat IP yang tetap dengan IP [prefix IP].3.69 (7)

### Jawaban
Menambahkan konfigurasi untuk fixed address pada `/etc/dhcp/dhcpd.conf`

Setelah itu tidak lupa untuk mengganti konfigurasi pada file `/etc/network/interfaces` dengan

![image](https://user-images.githubusercontent.com/61973814/141640383-4879cf60-e4ed-4b20-bea0-f76679cd5795.png)

Maka Skypie akan mendapatkan IP `10.44.3.69`

![image](https://user-images.githubusercontent.com/61973814/141630454-2fd5b108-abb8-4d60-a87c-1f9a4ac22833.png)

## Soal 8
Pada Loguetown, proxy harus bisa diakses dengan nama jualbelikapal.yyy.com dengan port yang digunakan adalah 5000 (8)

### Jawaban
water7 -> Proxy Server
- tambahkan konfigurasi pada `/etc/squid/squid.conf`
```
http_port 5000
visible_hostname jualbelikapal.t05.com
#http_access allow all
```
Melakukan restart service bind9 dengan `service bind9 restart`

EniesLobby
tambahkan konfigurasi pada `/etc/bind/named.conf.local` 
```
zone \"jualbelikapal.t05.com\" {
        type master;
        file \"/etc/bind/jarkom/jualbelikapal.t05.com\";
};
```

- Membuat Directory baru dengan mkdir `/etc/bind/jarkom/`
- Menambahkan konfigurasi pada `/etc/bind/jarkom/jualbelikapal.t05.com`

```
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
```
Melakukan restart service bind9 dengan `service bind9 restart`

***Testing***
- Jangan lupa aktifkan proxynya terlebih dahulu dengan `export http_proxy="http://jualbelikapal.t05.com:5000"`

- Ketika diakses akan tetap bisa menggunakan proxy

![image](https://user-images.githubusercontent.com/61973814/141643481-0ce971d2-be14-4563-87e8-fa13ddf668a5.png)



## Soal 9
Agar transaksi jual beli lebih aman dan pengguna website ada dua orang, proxy dipasang autentikasi user proxy dengan enkripsi MD5 dengan dua username, yaitu luffybelikapalyyy dengan password luffy_yyy dan zorobelikapalyyy dengan password zoro_yyy (9)

### Jawaban
Water7 - Proxy Server
tambahkan htpasswd pada file `/etc/squid/passwd` dengan
```
htpasswd -cbm /etc/squid/passwd luffybelikapalt05 luffy_t05
htpasswd -bm /etc/squid/passwd zorobelikapalt05 zoro_t05 
```

lalu tambahkan konfigurasi pada `/etc/squid/squid.conf`
```
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
```
lalu lakukan restart service squid dengan `service squid restart`

***TESTING***

- Pada konfigurasi `/etc/squid/passwd` terdapat username dan password yang sudah terenkripsi

![image](https://user-images.githubusercontent.com/61973814/141643750-36b1c21f-ba05-4529-9bd5-fbbe1d6ff426.png)


- pada saat web dijalankan akan diminta username dan password

![image](https://user-images.githubusercontent.com/61973814/141643481-0ce971d2-be14-4563-87e8-fa13ddf668a5.png)

## Soal 10
Transaksi jual beli tidak dilakukan setiap hari, oleh karena itu akses internet dibatasi hanya dapat diakses setiap hari Senin-Kamis pukul 07.00-11.00 dan setiap hari Selasa-Jum’at pukul 17.00-03.00 keesokan harinya (sampai Sabtu pukul 03.00) (10)

### Jawaban
- Menambahkan konfigurasi file pada `/etc/squid/acl.conf` di `water7` 
```
acl AVAILABLE_WORKING time MTWH 07:00-11:00
acl AVAILABLE_WORKING time TWHF 17:00-23:59
acl AVAILABLE_WORKING time WHFA 00:00-03:00

```

- Menambahkan konfigurasi pada `/etc/squid/squid.conf`
```
include /etc/squid/acl.conf

http_port 5000
visible_hostname Water7
#http_access allow all


auth_param basic program /usr/lib/squid/basic_ncsa_auth /etc/squid/passwd
auth_param basic children 5
auth_param basic realm Proxy
auth_param basic credentialsttl 2 hours
auth_param basic casesensitive on
acl USERS proxy_auth REQUIRED
http_access allow USERS AVAILABLE_WORKING
http_access deny all

```
Melakukan restart service squid dengan `service squid restart`


***TESTING***

- Ketika tidak pada hari dan jam kerja maka tidak akan bisa diakses
![image](https://user-images.githubusercontent.com/61973814/141643715-8a3b3f4c-fd8d-408e-9d37-e3a4c82243bc.png)




## Soal 11
Agar transaksi bisa lebih fokus berjalan, maka dilakukan redirect website agar mudah mengingat website transaksi jual beli kapal. Setiap mengakses google.com, akan diredirect menuju super.franky.yyy.com dengan website yang sama pada soal shift modul 2. Web server super.franky.yyy.com berada pada node Skypie (11)

### Jawaban
- Tambahkan konfigurasi pada /etc/bind/named.conf.local di `EniesLobby`
```
zone \"jualbelikapal.t05.com\" {
        type master;
        file \"/etc/bind/jarkom/jualbelikapal.t05.com\";
};

zone \"super.franky.t05.com\" {
        type master;
        file \"/etc/bind/kaizoku/super.franky.t05.com\";
};

```
- buat Directory baru dengan mkdir `/etc/bind/kaizoku/`
- Menambahkan konfigurasi pada `/etc/bind/kaizoku/super.franky.t05.com`
```
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
```
- Melakukan restart service bind9 dengan `service bind9 restart`

***Skypie***
- Membuat Directory baru dengan mkdir `/var/www/super.franky.t05.com`
- Mengambil konten dan melakukan unzip pada github dengan
```
wget https://raw.githubusercontent.com/FeinardSlim/Praktikum-Modul-2-Jarkom/main/super.franky.zip -O /root/super.franky.zip
unzip -o /root/super.franky.zip -d  /root
cp -r /root/super.franky/. /var/www/super.franky.t05.com/

```

Menambahkan konfigurasi pada `/etc/apache2/sites-available/super.franky.t05.com.conf`
```
<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/super.franky.t05.com
        ServerName super.franky.t05.com
        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined
        <Directory /var/www/super.franky.t05.com/public>
                Options +Indexes
        </Directory>
</VirtualHost>
```

Melakukan
```
a2ensite super.franky.t05.com
a2dissite 000-default  
```

***Skypie***

- Tambahkan konfigurasi pada `/etc/squid/squid.conf`
```
include /etc/squid/acl.conf

http_port 5000
visible_hostname Water7
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
```
Melakukan restart service squid dengan `service squid restart`

***TESTING***

- Lakukan ping pada `super.franky.t05.com`

![image](https://user-images.githubusercontent.com/61973814/141644732-de382bfc-a091-43c8-8ebe-3de5bacb178a.png)

- lakukan `lynx http://google.com`
- maka akan mengarahkan ke web `super.franky.t05.com`

![image](https://user-images.githubusercontent.com/61973814/141644827-02e1b74c-249c-409e-ac40-3d2abf1fedc9.png)

## Soal 12 dan 13
Saatnya berlayar! Luffy dan Zoro akhirnya memutuskan untuk berlayar untuk mencari harta karun di super.franky.yyy.com. Tugas pencarian dibagi menjadi dua misi, Luffy bertugas untuk mendapatkan gambar (.png, .jpg), sedangkan Zoro mendapatkan sisanya. Karena Luffy orangnya sangat teliti untuk mencari harta karun, ketika ia berhasil mendapatkan gambar, ia mendapatkan gambar dan melihatnya dengan kecepatan 10 kbps (12). Sedangkan, Zoro yang sangat bersemangat untuk mencari harta karun, sehingga kecepatan kapal Zoro tidak dibatasi ketika sudah mendapatkan harta yang diinginkannya (13)

### Jawaban
- Tambahkan konfigurasi pada file `/etc/squid/squid.conf` water7
```
include /etc/squid/acl.conf

http_port 5000
visible_hostname Water7
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
deny_info http://super.franky.t04.com lan

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

```

***TESTING***

- Ketika sebagai luffy dan mendownload gambar png atau jpg
    - Pertama, lakukan proxy terlebih dahulu dengan cara 
    ```
    export http_proxy="http://luffybelikapalt05:luffy_t05@jualbelikapal.t05.com:5000"
    ```
    - Selanjutnya lakukan wget pada 
    ```
    wget http://super.franky.t05.com/public/images/franky.png
    ```
    
    Hasilnya:
    
    ![image](https://user-images.githubusercontent.com/61973814/141644987-566f9ece-8da1-43d2-aaed-a70a9661c3b2.png)

- Ketika sebagai Zoro dan mendownload gambar png atau jpg
   - Pertama, lakukan proxy terlebih dahulu dengan cara
    
    ```
    export http_proxy="http://luffybelikapalt05:luffy_t05@jualbelikapal.t05.com:5000"
    ```
    
    - Selanjutnya lakukan wget pada 
    ```
    wget http://super.franky.t05.com/public/images/franky.png
    ```
    
    Hasilnya :
    
    ![image](https://user-images.githubusercontent.com/61973814/141645161-46a8d9b5-894d-41cb-b6b9-5aca48f0e95a.png)

