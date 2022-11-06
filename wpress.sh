!#bin/bash

##update apt
apt-get update && apt-get upgrade -y

##Install nginx
apt-get install nginx 

##Install MariaDB
apt-get install mariadb-server -y
systemctl enable mariadb.service
mysql_secure_installation

##install php
apt-get install php8.1 php8.1-cli php8.1-fpm php8.1-mysql php8.1-json php8.1-opcache php8.1-mbstring php8.1-xml php8.1-gd php8.1-curl 

#Download worpress and extract copy
wget https://wordpress.org/latest.tar.gz
echo "The latest WordPress release has been downloaded.What do you want the name of your website to be?"
read websitename
tar -xzvf latest.tar.gz
mkdir /var/www/$websitename
cp -R ./wordpress/* /var/www/$websitename/ 
echo $websitename "has been extracted" 
echo "Would you like me to configure your nginx code for" $websitename
read nginxconfig
if $nginxconfig="yes";
then 
   mv ./nginx-vhost-config/newhost.conf /etc/nginx/conf.d/$websitename.conf
   sed -i "s/wordpress/$websitename/" /etc/nginx/conf.d/$websitename.conf
   cd /etc/nginx/conf.d
   touch $websitename.conf
   
else
   echo "Nginx, php8.1, Mariadb has been installed. The latest WP release has been downloaded and extracted.Dont forget to configure nginx and your DB :)"
fi

echo "I will now configure your database"
echo "your mysql username will be $websitename. Please specify the password for this user"
read dbpassword
sed -i "s/wpress/$websitename" ./nginx-vhost-config/dbconfig.sql
sed -i "s/wpressuser/$websitename" ./nginx-vhost-config/dbconfig.sql
mysql -u root -p -e ./nginx-vhost-config/dbconfig.sql
rm /etc/nginx/sites-enabled/default
nginx -t 
nginx -s reload


