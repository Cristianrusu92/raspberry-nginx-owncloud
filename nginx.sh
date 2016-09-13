#!/bin/bash
Gre='\e[1;32m';   #defy the green color for the bash script
Blu='\e[1;34m';   #defy the blue color for the bash script
Re='\e[1;31m';    #defy the red color for the bash script

if [ $EUID -ne 0 ]; then
   echo -e "${Re}This script must be run as root" 1>&2
   tput sgr0
   exit 1
fi

# Start 

echo -n "Updating the system." && sleep 0.02m && echo "......" && sleep 0.02m 
pacman -Syu
echo "***********************************************************************" && sleep 0.005m
echo "***********************************************************************" && sleep 0.01m
echo "Checking Nginx instalation............." && sleep 0.02m

checknginx=$(pacman -Qs nginx)

if [ -n "$checknginx" ]
   then
       echo "Nginx is already installed" 
       testvar=$(systemctl status nginx | awk '/active/ { print $2 } ')
       if [ "$testvar" = "active" ]
            then        
                 echo "Nginx is already activated. No need to activate it"
		 testvar2=$(systemctl status nginx | awk '/bled/ { print $4 } ' | sed 's/;//' )
                 
                 if [ "$testvar2" = "enabled" ]
                    then
                        echo "..............Nginx autostart function is enabled. OK"
			echo -e "Nginx ${Gre}Activated & Enabled."
                        tput sgr0

                 else
                    echo "Enabeling the nginx autostart function......" && sleep 0.02m
                    systemctl enable nginx
                    echo -e "Nginx ${Gre}Activated & Enabled."
                    tput sgr0 
                 fi 

        else
            echo "Nginx is not active. The script is activating & enabeling it.........." && sleep 0.02m 
            systemctl start nginx && systemctl enable nginx && sleep 0.02m
            echo -e "Nginx ${Gre}Activated & Enabled."
            tput sgr0
        fi    

else 
    echo "Installing nginx...." && sleep 0.02m
    pacman -S nginx
    systemctl start nginx && systemctl enable nginx && sleep 0.02m
    echo -e "Nginx ${Gre}Activated & Enabled."
    tput sgr0


fi

sleep 0.01m
echo "Checking to install MariaDB..............." && sleep 0.02m


checkMaria=$(pacman -Qs mariadb | awk -F/ '/mariadb/ { print $2 } '| grep "^mariadb")

#echo "$checkMaria"

if [ -n "$checkMaria" ]
   then 
       echo -e "MariaDB is already ${Gre}installed"
       tput sgr0
else 
       pacman -S mariadb
       echo -e "MariaDb is ${Gre}Installed"
       tput sgr0

fi

echo "Initializing the MariaDB data directory as prior to starting the service...." 

systemctl stop mysqld

mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

echo "Done"

echo "Starting MariaDB......" 


mariaStart=$(systemctl status mysqld | awk '/active/ { print $2 } ' | awk '/active/ { print } ')

if [ "$mariaStart" = "inactive" ]
   then 
       echo " Activating MariaDB....."  &&  sleep 0.01m
       systemctl start mysqld
       ismariaopen=$(systemctl status mysqld | awk '/active/ { print $2 } ' | awk '/active/ { print } ')
       if [ "$ismariaopen" = "active" ]
          then
              echo -e "MariaDb is now ${Gre}Started"
              tput sgr0
          else
              echo "MariaDB is still not active. Something went wrong!"
	  fi 
fi    

disabledMaria=$(systemctl status mysqld | awk '/bled/ { print $4 } ' | awk '/bled/ { print }' |sed 's/;//' )

if [ "$disabledMaria" = "disabled" ]
   then 
       echo "MariaDB autostart function is $disabledMaria"
       echo "Enabling MariaDB autostart function............"
       systemctl enable mysqld
else 
       echo "MariaDB is $disabledMaria"
fi

echo "Running the post-installation security script................"
echo "(1)Press Enter and set a new root mysql passord" & sleep 0.01m
echo "(2)Remove the test database and anonymous user!"
echo "(3)Reload the privileges tables"
echo "(4)Disable the root remote login!" & sleep 0.03m

# Running the first time use script for mariadb

mysql_secure_installation

echo "Installing the Archlinux-PHP repository called: php-fpm......................." && sleep 0.05m


phpmodule=$(pacman -Qs php-fpm)


if [ -z "$phpmodule" ]
   then 
	echo $phpmodule
	pacman -S php-fpm

else
    echo "The PHP module is already installed on your system"
    
fi

echo "....................................." && sleep 0.01m
echo ".............................."  && sleep 0.01m
echo "Enabeling the database extension in the PHP module......"
echo "Deleting the ; in mysqli.so"
sed -i "875s/;extension=mysqli.so/extension=mysqli.so/" /etc/php/php.ini
echo "Deleting the ; in pdo_mysql.so"
sed -i "879s/;extension=pdo_mysql.so/extension=pdo_mysql.so/" /etc/php/php.ini


echo -e "${Gre}Ready"
tput sgr0


echo -e "${Blu}Installing owncloud"
tput sgr0

owncloudvar=$(pacman -Qs owncloud)

if [ -n "$owncloud" ]
  then 
     echo "$owncloud"
     pacman -S owncloud
     echo -e "${Blu}Owncloud installed."
     tput sgr0 
  else
     echo "$owncloud"
     echo "Owncloud is already installed"
fi

echo "Changing the permissions for the /usr/share/webapps/owncloud"

chown http:http /usr/share/webapps/ -R


echo -e "${Blu}Creating the owncloud database...."
tput sgr0

read  -sp 'Enter a password for your owncloud database:' userdata

echo " "
read  -sp 'Enter it again:' userdata2
echo " "

if [ "$userdata" = "$userdata2" ]
   then        
      echo "Passwords matches."
else
   echo "Passwords doesn't mach"
   exit
fi

read  -sp 'Enter the password for your root mysql database:' userdatamysql

echo " "
read  -sp 'Enter it again:' userdata2mysql
echo " "

if [ "$userdatamysql" = "$userdata2mysql" ]
   then        
      echo "Passwords matches."
else
   echo "Passwords doesn't mach"
   exit
fi


testuser=$(mysql -u root -p$userdatamysql -e 'select user, host from mysql.user;' | grep owncloud)


if [ -z "$testuser" ]
  then
      Q1="create database owncloud;"
      Q2="create user ownclouduser@localhost identified by '$userdata';"
      Q3="grant all privileges on owncloud.* to ownclouduser@localhost identified by '$userdata';"
      Q4="flush privileges;"
      SQL="${Q1}${Q2}${Q3}${Q4}"
      echo $SQL
      mysql -u root -p$userdatamysql -e "$SQL"
     
  else
      echo -e "${Re}The owncloud@localhost is already in the mariadb user database"
      tput sgr0
  
fi

#Reset the root password in mysql : mysql -u root -p{The_root_password} -e "SET PASSWORD FOR root@localhost=PASSWORD('');"


logbin=$(cat /etc/mysql/my.cnf | awk ' /log-bin=mysql-bin/ { print NR-1, $0 } '| awk '$2 ~ /^ *#/ ')

if [ -n "$logbin" ]
  then
    logbinnumber=$(echo "$logbin" | tr -dc '0-9' )
    echo " "
    echo -e  "${Re}Removing the '#' from log-bin=mysql-bin"
    tput sgr0
    echo -e "${Gre}$logbinnumber"
    tput sgr0
    let "real_logbinnuber=logbinnumber + 1 "
    sed -i "${real_logbinnumber}s/#log-bin=mysql-bin/log-bin=mysql-bin/" /etc/mysql/my.cnf
    echo "$real_logbinnuber"

fi

systemctl restart mysqld

echo " "
echo -e "${Blu}Creating the Nginx Configuration File for owncloud"
tput sgr0
echo " "
echo " "

filestring="/etc/nginx/conf"

if [ -d "$filestring" ]
 then
    echo "/etc/nginx/conf directory already exists"
  else 
    mkdir /etc/nginx/conf
fi

location_nginx=$(pwd)


echo "Current directory $location_nginx"
cp "$location_nginx/owncloud.conf" /etc/nginx/conf


sed -i "869s/;extension=gd.so/extension=gd.so/" /etc/php/php.ini
sed -i "877s/;extension=mysqli.so/extension=mysqli.so/" /etc/php/php.ini
sed -i "881s/;extension=pdo_mysql.so/extension=pdo_mysql.so/" /etc/php/php.ini

systemctl restart nginx
systemctl restart php-fpm

echo  -e "Your owncloud configuration is ${Gre}Ready"
tput sgr0

echo "You can use the configuration by accessing your ip address or you can set a DNS address in /etc/nginx/conf/owncloud.conf by setting both the 'listen' parameteres with your DNS "

echo "Also run the other script to set up the automate TSL/SSL certificate creation to reinstall your Certbot certificate on a specified period of time. "

echo -e "${Gre}Ready"
tput sgr0

