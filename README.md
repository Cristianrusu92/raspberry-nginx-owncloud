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
A easy way to find out the ip adrees is to use a script that automatically tells you the device ip. The script in this repo so you can download it. You have install java dev tool in oreder to execute it from the command line. By typing ` sudo pacman -S jdk7-openjdk ` you can intall it on you Arch system. After the instalation just execute `java -jar pi-oi.jar` and you will see a script running in your command line. After a few second the script prompts you with the ip. 
