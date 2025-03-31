#!/bin/sh

ROOTFS_DIR=$(pwd)
export PATH=$PATH:~/.local/usr/bin
max_retries=50
timeout=1
ARCH=$(uname -m)

if [ "$ARCH" = "x86_64" ]; then
  ARCH_ALT=amd64
elif [ "$ARCH" = "aarch64" ]; then
  ARCH_ALT=arm64
else
  printf "Unsupported CPU architecture: ${ARCH}"
  exit 1
fi
set ubuntu_ver = "2"
if [ ! -e $ROOTFS_DIR/.installed ]; then
  echo
  echo "###################"
  echo "# 1) Ubuntu 22.04 #"
  echo "# 2) Ubuntu 24.04 #"
  echo "###################"
  echo
  read -p "Ubuntu version (1/2, default 2): " ubuntu_ver
  if [ "$ubuntu_ver" -ne 1 ] && [ "$ubuntu_ver" -ne 2 ]; then
    echo
    echo "Wrong version!"
    echo "Choose 1 or 2"
    echo
    exit
  fi
  install_ubuntu=YES
fi

case $install_ubuntu in
  [yY][eE][sS])
    if [ "$ubuntu_ver" == "1" ]; then
      wget --tries=$max_retries --timeout=$timeout --no-hsts -O rootfs.tar.gz "https://raw.githubusercontent.com/womimc/ubuntu-rootfs/refs/heads/main/ubuntu-base-22.04.5-base-${ARCH_ALT}.tar.gz"
    elif [ "$ubuntu_ver" == "2" ]; then
      wget --tries=$max_retries --timeout=$timeout --no-hsts -O rootfs.tar.gz "https://raw.githubusercontent.com/womimc/ubuntu-rootfs/refs/heads/main/ubuntu-base-24.04.2-base-${ARCH_ALT}.tar.gz"
    fi
    tar -xf rootfs.tar.gz -C $ROOTFS_DIR
    rm rootfs.tar.gz
    ;;
  *)
    echo "Skipping Ubuntu installation."
    ;;
esac

if [ ! -e $ROOTFS_DIR/.installed ]; then
  mkdir $ROOTFS_DIR/usr/local/bin -p
  wget --tries=$max_retries --timeout=$timeout --no-hsts -O $ROOTFS_DIR/usr/local/bin/proot "https://raw.githubusercontent.com/womimc/root/main/proot-${ARCH}"

  while [ ! -s "$ROOTFS_DIR/usr/local/bin/proot" ]; do
    rm $ROOTFS_DIR/usr/local/bin/proot -rf
    wget --tries=$max_retries --timeout=$timeout --no-hsts -O $ROOTFS_DIR/usr/local/bin/proot "https://raw.githubusercontent.com/womimc/root/main/proot-${ARCH}"

    if [ -s "$ROOTFS_DIR/usr/local/bin/proot" ]; then
      chmod 755 $ROOTFS_DIR/usr/local/bin/proot
      break
    fi

    chmod 755 $ROOTFS_DIR/usr/local/bin/proot
    sleep 1
  done

  chmod 755 $ROOTFS_DIR/usr/local/bin/proot
fi

if [ ! -e $ROOTFS_DIR/.installed ]; then
  printf "nameserver 1.1.1.1\nnameserver 1.0.0.1" > ${ROOTFS_DIR}/etc/resolv.conf
  touch $ROOTFS_DIR/.installed
fi

CYAN='\e[0;36m'
WHITE='\e[0;37m'

RESET_COLOR='\e[0m'

clear

$ROOTFS_DIR/usr/local/bin/proot \
  --rootfs="${ROOTFS_DIR}" \
  -0 -w "/root" -b /dev -b /sys -b /proc -b /etc/resolv.conf --kill-on-exit su
