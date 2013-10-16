#!/bin/bash
set -e

export TERMINFO=/share/terminfo

IMAGE_PATH=snack_mnt

########################################
###### Rudimentary Failsafe for	   #####
###### MsgBox			   #####
########################################

msg (){
type -P dialog 2>/dev/null && msgbx || {
echo -e  "\033[1;31m There is either a problem with Ncurses or Dialog\033[0m"
echo -e "\v\t  Format partitions wiping all data:"
while true; do 
  read -p "Continue? Y\n" yn
  case $yn in
	[Y]* ) echo Continuing...; break;;
	[Nn]* ) echo "exiting"; exit 255;;
	* ) echo "Y\n" 
  esac
done
}
}
msgbx (){
  dialog  --yesno "Format partitions wiping all data and install SnackLinux?" 10 50
	[[ $? != 0 ]] && exit 255
}
	
# In my humble opinion it'd be nice to clean this up by making some functions
# in a separate script and then calling them.  That way we can avoid errors
# easier.  I attempted to, but it became messy.

# Check parameter and path


if [ "$#" == "0" ]; then
  echo
  echo "Usage: $0 DEVICE"
  echo
  echo "       DEVICE=/dev/hd[a-d] -> install SnackLinux on to hard disk"
  echo "       DEVICE=/dev/sd[a-b] -> install SnackLinux on to hard disk"
  echo
  echo "  Ex: $0 /dev/hdc"
  echo "      $0 /dev/sda"
  echo
  exit 0
fi

# Create the image path if it doesn't exist

if [ ! -d "$IMAGE_PATH" ]; then
  mkdir $IMAGE_PATH
fi

# I'll throw the msg function here because this is where it kind of starts

msg

echo
echo "Installing SnackLinux onto $1"
echo

# fdisk commands to delete partitons 1-4, create a bootable and secondary partition
cat > fdisk.in << "EOF"
d
1
d
2
d
3
d
4
n
p
1

+4M
a
1
t
1
n
p
2


w
EOF

echo "Making partitions"

fdisk $1 < ./fdisk.in > /dev/null
  
echo "Formatting $1"1
  
mkdosfs "$1"1 > /dev/null 2>&1


#Format the second partition
echo "Formatting $1"2
mke2fs -j "$1"2 > /dev/null 2>&1
echo "Mounting $1 as $IMAGE_PATH"2
mount "$1"2 $IMAGE_PATH  


# Make directories and copy files

cd $IMAGE_PATH

echo "Creating directories"
mkdir -v dev boot etc bin home lib mnt proc root sbin sys tmp usr var usr/bin usr/sbin var/run var/lib var/lock var/log share
chmod -R 755 *

echo "Copying directories"
cp /init ./
chmod 755 ./init

cp -a {/bin,/etc,/home,/sbin,/var,/usr,/share} ./
chmod -R 755 .{/bin,/etc,/home,/sbin,/var,/usr,/share}/*

cp -a {/lib,/tmp,/usr/lib} ./
chmod -R 777 .{/lib,/tmp,/usr/lib}/*

echo "Creating device nodes"
mknod -m 600 dev/console c 5 1
mknod -m 666 dev/full c 1 7
mknod -m 666 dev/kmem c 1 2
mknod -m 666 dev/mem c 1 1
mknod -m 666 dev/null c 1 3
mknod -m 666 dev/port c 1 4
mknod -m 444 dev/random c 1 8
mknod -m 444 dev/urandom c 1 9
mknod -m 666 dev/zero c 1 5
mknod -m 666 dev/ram0 b 1 0
mknod -m 666 dev/ptmx c 5 2

mknod -m 644 dev/hda b 3 0
mknod -m 644 dev/hdb b 3 64
mknod -m 644 dev/sda  b 8 0
mknod -m 644 dev/sda1 b 8 1
mknod -m 644 dev/sda2 b 8 2
mknod -m 644 dev/tty c 5 0
mknod -m 644 dev/tty0 c 4 0
mknod -m 644 dev/tty1 c 4 1 
mknod -m 644 dev/tty2 c 4 2
mknod -m 644 dev/tty3 c 4 3
mknod -m 644 dev/tty4 c 4 4
mknod -m 644 dev/tty5 c 4 5
mknod -m 644 dev/vcs0 b 7 0

cp -avp /dev/core   dev
cp -avp /dev/stderr   dev
cp -avp /dev/stdin   dev
cp -avp /dev/stdout   dev

mkdir -v dev/shm
mkdir -v dev/pts

echo "Syncing"
sync

cd ..




#Create a lilo conf file so we can install lilo right away
cat > ./$IMAGE_PATH/etc/lilo.conf << "EOF"
boot=/dev/sda
prompt
timeout=50
lba32
default=snacklinux

image=/boot/bzImage
	label=snacklinux
	root=/dev/sda2

EOF


#Copy the kernel image over
cp /boot/bzImage $IMAGE_PATH/boot/bzImage

echo "Writing lilo to the MBR"
lilo -r $IMAGE_PATH  -M "$1"


#Install lilo relative to the mount
lilo -r $IMAGE_PATH  

echo "Umounting $1"2
umount "$1"2
  
rm -rf $IMAGE_PATH

echo "Done!"