apt-get update
# nomor 8
apt-get install apache2 -y
service apache2 start
apt-get install php -y
apt-get install libapache2-mod-php7.0 -y
apt-get install ca-certificates openssl -y
apt-get install git -y
apt-get install unzip -y
apt-get install wget -y
apt-get install lynx -y


# nomor 11
mkdir /var/www/super.franky.t05.com

wget https://raw.githubusercontent.com/FeinardSlim/Praktikum-Modul-2-Jarkom/main/super.franky.zip -O /root/super.franky.zip
unzip -o /root/super.franky.zip -d  /root
cp -r /root/super.franky/. /var/www/super.franky.t05.com/

echo "
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
" > /etc/apache2/sites-available/super.franky.t05.com.conf
a2ensite super.franky.t05.com
a2dissite 000-default  
service apache2 restart

export http_proxy="http://jualbelikapal.t05.com:5000"
