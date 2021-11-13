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


## Soal 6
Lama waktu DHCP server meminjamkan alamat IP kepada Client yang melalui Switch1 selama 6 menit sedangkan pada client yang melalui Switch3 selama 12 menit. Dengan waktu maksimal yang dialokasikan untuk peminjaman alamat IP selama 120 menit. (6)

### Jawaban

## Soal 7
Luffy dan Zoro berencana menjadikan Skypie sebagai server untuk jual beli kapal yang dimilikinya dengan alamat IP yang tetap dengan IP [prefix IP].3.69 (7)

### Jawaban

## Soal 8
Pada Loguetown, proxy harus bisa diakses dengan nama jualbelikapal.yyy.com dengan port yang digunakan adalah 5000 (8)

### Jawaban

## Soal 9
Agar transaksi jual beli lebih aman dan pengguna website ada dua orang, proxy dipasang autentikasi user proxy dengan enkripsi MD5 dengan dua username, yaitu luffybelikapalyyy dengan password luffy_yyy dan zorobelikapalyyy dengan password zoro_yyy (9)

### Jawaban

## Soal 10
Transaksi jual beli tidak dilakukan setiap hari, oleh karena itu akses internet dibatasi hanya dapat diakses setiap hari Senin-Kamis pukul 07.00-11.00 dan setiap hari Selasa-Jum’at pukul 17.00-03.00 keesokan harinya (sampai Sabtu pukul 03.00) (10)

### Jawaban

## Soal 11
Agar transaksi bisa lebih fokus berjalan, maka dilakukan redirect website agar mudah mengingat website transaksi jual beli kapal. Setiap mengakses google.com, akan diredirect menuju super.franky.yyy.com dengan website yang sama pada soal shift modul 2. Web server super.franky.yyy.com berada pada node Skypie (11)

### Jawaban

## Soal 12 dan 13
Saatnya berlayar! Luffy dan Zoro akhirnya memutuskan untuk berlayar untuk mencari harta karun di super.franky.yyy.com. Tugas pencarian dibagi menjadi dua misi, Luffy bertugas untuk mendapatkan gambar (.png, .jpg), sedangkan Zoro mendapatkan sisanya. Karena Luffy orangnya sangat teliti untuk mencari harta karun, ketika ia berhasil mendapatkan gambar, ia mendapatkan gambar dan melihatnya dengan kecepatan 10 kbps (12). Sedangkan, Zoro yang sangat bersemangat untuk mencari harta karun, sehingga kecepatan kapal Zoro tidak dibatasi ketika sudah mendapatkan harta yang diinginkannya (13)

### Jawaban
