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

'''
