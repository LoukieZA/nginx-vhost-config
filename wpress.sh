!#bin/bash

##update apt
apt-get update && apt-get upgrade -y

##Install nginx
sudo apt-get install nginx-full -y
sudo systemctl start nginx
sudo systemctl enable nginx

##Install MariaDB
apt-get install mariadb-server -y
systemctl enable mariadb.service
mysql_secure_installation

##Install MariaDB and PHP
sudo apt-get install php ph7.4-mysql ph7.4-fpm ph7.4-curl ph7.4-gd ph7.4-intl ph7.4-mbstring ph7.4-soap ph7.4-xml ph7.4-xmlrpc ph7.4-zip mariadb-server mariadb-client ph7.4-json
sudo systemctl start mariadb
sudo systemctl enable mariadb
sudo systemctl start php7.4-fpm
sudo systemctl enable php7.4-fpm
sudo systemctl status php7.4-fpm
sudo mysql_secure_installation

##Download worpress and extract copy
wget https://wordpress.org/latest.tar.gz
echo "The latest WordPress release has been downloaded.What do you want the name of your website to be?"
read websitename
tar -xzvf latest.tar.gz
mkdir /var/www/html/$websitename
cp -R ./wordpress/* /var/www/html/$websitename/
sudo chown -R www-data:www-data /var/www/html/$websitename/
sudo chmod -R 755 /var/www/html/$websitename/ 
echo $websitename "has been extracted" 
echo "configuring the nginx webserver" $websitename

##Replace git files defaults with defined variables 
mv ./nginx-vhost-config/newhost.conf /etc/nginx/conf.d/$websitename.conf
sed -i "s/wordpress/$websitename/" /etc/nginx/conf.d/$websitename.conf
   
   
##DB creation and configuration
echo "Nginx, php8.1, Mariadb has been installed. The latest WP release has been downloaded and extracted.Configuring DB :)"
sed -i "s/wpress/$websitename" ./nginx-vhost-config/dbconfig.sql
sed -i "s/wpressuser/$websitename" ./nginx-vhost-config/dbconfig.sql
mysql -u root -p -e ./nginx-vhost-config/dbconfig.sql
rm /etc/nginx/sites-enabled/default
nginx -t 
nginx -s reload


