# OwncloudConfig-Raspberry-Arch
This are a set of steps that I have followed in order to set a owncloud&amp;nginx server on my Archlinux&amp;RaspberryPI3


##                                Raspberry Pi                       Configuration Manual    



#### 1.Set up the sd card for Raspberry PI
In order to have a working archlinux arm on the raspberry.You have to follow up the instructions from the official [Arch Linux Arm site](https://archlinuxarm.org/platforms/armv8/broadcom/raspberry-pi-3). *Remeber that this site presumes you have already a working Linux system, so all the commands are in the linux shell.
There is not a .img in order to make a bootable card in rufus or other similar programs* After you inserted the sd card you have to umount it first `sudo umount /dev/sdb1 /dev/sdb2`  


#### 2.Connect the Raspberry 
Power up the device by connecting it to a 5V 2.5A power supply. I found that it works well with a 5V cellphone charger to. And finally you can connect the internet cable to the router LAN port. 


#### 3.Enstablish a SSH connection 
To make it easy the OpenSHH is active by default in ArchLinux. So you only need to find out the ip of your raspberry pi to be able to connect to it. 
A easy way to find out the ip adrees is to use a script that automatically tells you the device ip. The is script in this guy 
[repo](http://github.com/thoqbk/pi-oi) so you can download it. You have to install java dev tool in order to execute it from the command line. By typing ` sudo pacman -S jdk7-openjdk ` you can install it on your Arch system. After the instalation, just execute `java -jar pi-oi.jar` where your script is downloaded and you will see a script running in your command line. After a few seconds the script prompts you with the ip. 
Here is a example view of the script 

```
PI-OI is finding your Pi ...
+-----------------------------------------------------------------------------------------+
| Address            | Host response                          | Could be a Pi    | Time   |
+-----------------------------------------------------------------------------------------+
| 192.168.0.105      | SSH-2.0-OpenSSH_7.3                    |                  | 11s    |
+-----------------------------------------------------------------------------------------+
Tho Q Luong, http://github.com/thoqbk/pi-oi
```

Another  way to find out the ip is trough your router settings panel. Login to your router by accesing his ip lan adress. Usualy is on the back of you router. In the setting panel you will see device connected and the hostname of your pi which will be alarmpi and the ip.

Connect to ssh by typing `sudo ssh@your-raspberry-ip` and enter the `alarm` password.
Once conncted you need root privileges. Type `su` and enter the `root` password 


#### 4.WIFI activation 
The Raspberry Pi 3 has a build in  wirelless module. You can activate it by accesing a default command line tool called __wifi-menu__. Type 
`# wifi-menu -o`. You will see a interface prompt and you need to enter the password for your netword SSID. After that wait a few seconds. 
The wifi-menu utility has created a new profile for your WIFI Link. It is called wlan0-your-SSID 

Start the wifi by typing `netctl start wlan0-you-SSID`. Enable it so after each reboot it will be activate by typing `netctl enable 
wlan0-your-SSID` 

To see the profiles of your wifi type `netclt list`

#### 5. System update and syncronization
 
   `# pacman -Syy` <br />
   `# pacman -Syu` <br />

#### 5.Install sudo 
sudo allows a system administrator to delegate authority to give certain users or groups of users the ability to run commands as 
root or another user while providing an audit trail of the commands and their arguments.
<br />
`# pacman -S sudo` <br /> 


#### 6.Add User & User deletion
 [Arch Documentation](https://wiki.archlinux.org/index.php/users_and_groups) offers useful information regarding user management.
To add a user type : <br />
  
   `# useradd -m -G wheel -s /bin/bash yourUsername` <br />
   `# passwd yourUsername` <br />

This will create a group called yourUSername with the same GID and UID as the use yourUsername and make this the default group for 
yourUsername on login <br />

Next you have to remove the default alarm user by security reasons. But first you cannot delete it because your ssh is using it curently so 
you have to reconnect with your new user created.<br /><br />
`sudo ssh yourUsername@your-raspbery-ip`<br />
`# userdel -r alarm` <br />
The `-r` option specifies that the user's home directory and mail spool should also be deleted <br />

__User Database__: Local user information is stored in the plain-text `/etc/passwd` file.Each of its lines represents a user acount and has 
seven fields delimited by a colo `:`

#### 7.Add a User to sudo

`# nano etc/sudoers` <br />
Add the line unde the `root ALL=(ALL) ALL`  <br />

`yourUsername ALL=(ALL) ALL` <br />

SAVE and EXIT 


#### 8.Intall WGET & GIT & Yaourt

<br />
```
sudo pacman -S wget 
sudo pacman -S git 
sudo pacman -S base-devel 
cd ~/ && mkdir yar 
wget https://aur.archlinux.org/cgit/aur.git/snapshot/package-query.tar.gz 
tar -xzvf package-query.tar.gz 
cd package-query
makepkg -si
cd .. 
wget https://aur.archlinux.org/cgit/aur.git/snapshot/yaourt.tar.gz
tar -xzvf yaourt.tar.gz
cd yaourt
makepkg -si
cd ../..
rm -rf yar
```

#### 8.Set hostanme and root password

First verify your hostname by: `$ hostname` <br />
Then add `sudo hostname set-hostname NewHostnameHere` <br />

Add a new root password by typing the following command: <br />
```
   su
   passwd
```



#### 9.Change local time and generate new keyboard layout


`sudo nano etc/locale.gen`  Remove the `;` from `en_US.UTF-8 UTF-8` <br /

Save and exit and add `locale-gen`  <br />

````
  ls -l /etc/localtime
  rm /etc/localtime
  ln -s /usr/share/zoneinfo/Europe/Bucharest /etc/localtime

```
   
#### 10. Use the nginx.sh script to automate the owncloud configuration

`cd ~`

Clone the git repository by typing `git clone https://github.com/cristiangabor/OwncloudConfig-Raspberry-Arch.git`. Then enter the directory cloned: `cd ~/OwncloudConfig-Raspberry-Arch/`


I wrote a bash script that autmoates the installation and configuration of owncloud/nginx for your raspberry pi. Access the nginx.sh script from your git cloned repository and change the permissions in oreder to be able to execute it. To do that type:

`sudo chmod 755 nginx.sh`

After that you can execute the script by typing: `sudo ./nginx.sh` . Remember to execute the script with `sudo`. The script will update the system, install nginx, install mariadb and create a database, install the owncloud and php-fpm module. 

You will be asked to enter a new root password when the database will be created. I recomand you to enter a new one. You could also press enter to skip this but I recommend you to add a new one and diffrent from the owncloud database password to increase the security. 

After the script is runned you need to modify the `server_name` from /etc/nginx/conf/owncloud.conf. You need to substitute with your own DNS server name. If do not have owne, I recommend you to access [no-ip site](http://www.noip.com/) and make one. Replace the:

```
 server {

 
 listen   80;
 server_name localhost    #with/  myowncloud.no-ip.com;
 
  .......
}
 
  server {
  listen 443 ssl;
  server_name localhost  #with  myowncloud.no-ip.com;

  .....
 }

 ```

The final step is to set a port forwarding on your router to make the owncloud accessible on the 443 external port. This is a really important step. Skipping this step can make the server owncloud not to work, so pay atention! 

Enter the router configuration panel by accessing his own ip: Usualy the ip is writen on the back of the router. Like `192.168.0.1` . Access the advacend section and there you will see a section: Port Forwarding. This [tutorial](https://pimylifeup.com/raspberry-pi-port-forwarding/) is really useful to see how it's done. The internal port needs to be `443` and also the external port needs to be `443`. You may have a problem after setting this with http redirect. You only need to enter on the browser link section `https://followed-by-your-onwcloud.adress.com`. After this the browser will remember your adress, so there is no need to type it again.

That's it with this step. 


#### 11.Add external hard drive to your owncloud server

To expand the capabilities of your owncloud server you can add a external hardrive. For this you need first identificate the unique id of your 
hard drive. 

To see your hard drive id: `ls -l /dev/disk/by-uuid` .  You will see a short key for fat32 partions like: ` 503A-ABB5`. Copy the key. 

Get the id of `http` user. Remember that we gaved the ownership of `/usr/share/webapps/owncloud/` (where the owncloud files are) to `http` 
user. <br />
`id -g http` <br />
`id -u http` <br />

Add this line at the end of the /etc/fstab file. Remember to substitue the `UUID=`,`uid` and `gid` with your hard drive id, http user id and http group id.

`UUID=503A-ABB5 /media/owncloud vfat nofail,x-systemd.device-timeout=1,uid=33,gid=33,umask=0027,dmask=0027  0 0`

Restart the raspberry. `sudo reboot`

Activate the owncloud external storage in the application menu. Add your hard drive to the Local directory and specify the path where is 
mounted `/media/owncloud`. Here is a useful [video](https://www.youtube.com/watch?v=uezzFDRnoPY).
   

#### 12.Obtain a Free Let’s Encrypt TLS/SSL Certificate

SSL Certificates are small data files that digitally bind a cryptographic key to an organization’s details. When installed on a web server, it activates the padlock and the https protocol and allows secure connections from a web server to a browser. Typically, SSL is used to secure credit card transactions, data transfer and logins, and more recently is becoming the norm when securing browsing of social media sites.


To obatin this you need to install the certbot program from arch repository

`sudo pacman -S certbot` <br /> 

Run the command to obtain the certificate

`sudo certbot certonly --webroot --email <your-email-address> -d www.example.com  -w /usr/share/nginx/html/` <br />

Replace --email with your email, -d is your nginx server_name, -w is short for --webroot-path. /usr/share/nginx/ is a common Nginx Web root. 

Edit the /etc/nginx/conf/owncloud.conf and add these lines under server_name: <br />

```
ssl_certificate      /etc/letsencrypt/live/www.example.com/fullchain.pem;
ssl_certificate_key  /etc/letsencrypt/live/www.example.com/privkey.pem;

```

Replace www.example.com with your server_name

Restart the nginx: `sudo systemctl restart nginx`

The certificates expires every 90 days. You need to renew ssl certificate after this period. Make a crontab task to automate this process to do it for you monthly.

Install cronie. `sudo pacman -S cronie`. Create a crontab task with `EDITOR=nano crontab -e`. The editor variable is there to specify the editor. By default crontab will use vim. <br />

Add this line and exit: `@monthly certbot certonly --webroot --email <your-email-address> -d www.example.com -w /usr/share/nginx/html` <br />

The command will run at 00:00 on 1st day of every month.

To view their crontabs, users should issue the command: `crontab -l`. Here you can read more about [cronie](https://wiki.archlinux.org/index.php/cron).


#### 13. Make a VPN & SSH connection

Connecting via WAN with SSH you need to make a virtual private network. A VPN is a private network that uses a public network (usually the Internet) to connect remote sites or users together. The VPN uses "virtual" connections routed through the Internet from the business's private network to the remote site or employee. By using a VPN, businesses ensure security -- anyone intercepting the encrypted data can't read it.

Find out your public ip: `curl http://icanhazip.com` . This ip is set by your network provider. You are able to connect to it with ssh but first you need to open the 22 port. This port is for your ssh communication. Open it in your router by connecting to it and for: <br />

1.ip - your raspberry ip (ex:192.168.0.102)
2.internal port - your internal port (22)
3.external(service) port - your external port (22) <br / >

Right now you will have 2 ports open for your raspberry: <br />

1.The 443 port for your owncloud
2.The 22 port for your ssh


Access it outside the network by: `ssh raspberry_user_name@public_ip`

You can access it also by your dns name. If you have a DNS set (some provider offer the possibilty to link the DNS by your public ip automaticaly) you can replace it: `ssh raspberry_user_name@DNS_name`

If you don't have a DNS set. Most probably you will find in your router settings panel how to set one. 

