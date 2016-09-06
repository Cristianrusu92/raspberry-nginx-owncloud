# OwncloudConfig-Raspberry-Arch
This are a set of steps that I have followed in order to set a owncloud&amp;nginx server on my Archlinux&amp;RaspberryPI3


##                                Raspberry Pi                       Configuration Manual    



#### 1.Set up the sd card for Raspberry PI
In order to have a working archlinux arm on the raspberry.You have to follow up the instructions from the official [Arch Linux Arm site](https://archlinuxarm.org/platforms/armv8/broadcom/raspberry-pi-3). *Remeber that this site presumes you have already a working Linux system, so all the commands are in the linux shell.
There is not a .img in order to make a bootable card in rufus or other similar programs* After you inserted the sd card you have to umount it first `sudo umount /dev/sdb1 /dev/sdb2`  


#### 2.Connect the Raspberry 
Power up the device by connecting it to a 5V 2.5A power supply. I found that it works well with a 5V cellphone charger to. And finally you can connect the internet cable to the router LAN port. 



