!#bin/bash

##update apt
apt-get update && apt-get upgrade -y

##Install nginx
sudo apt-get install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx

##Install MariaDB
apt-get install mariadb-server -y
systemctl enable mariadb.service
mysql_secure_installation

##Install MariaDB and PHP
sudo apt-get install php php-mysql php-fpm php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip mariadb-server mariadb-client php-json
sudo systemctl start mariadb
sudo systemctl enable mariadb
sudo systemctl start php8.1-fpm
sudo systemctl enable php8.1-fpm
sudo systemctl status php8.1-fpm
sudo mysql_secure_installation

##Download worpress and extract copy
wget https://wordpress.org/latest.tar.gz
echo "The latest WordPress release has been downloaded.What do you want the name of your website to be?"
read websitename
tar -xzvf latest.tar.gz
mkdir /var/www/$websitename
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


