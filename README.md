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
Once connceted you need root privileges. Type `su` and enter the `root` password 


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

First verify your hostname by: <br />
`hostname` <br />
Then add the : `sudo hostname set-hostname NewHostnameHere' <br />

Add a new root password by typing the following command: <br />
```
   su
   passwd
```




   
