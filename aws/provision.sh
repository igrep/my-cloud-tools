#!/bin/bash

# setup options
while [ -n "$1" ] ; do
  case $1 in
    --user-name)
      user_name=$2
      ;;
    --password)
      password=$2
      ;;
    --ssh-port)
      ssh_port=$2
      ;;
    *)
      echo "Unknown option: '$1'" 1>&2
      exit 1
      ;;
  esac
  shift 2
done
if [ -n "$user_name" ]; then
  echo "Not specified user-name" 1>&2
  exit 1
fi
if [ -n "$password" ]; then
  echo "Not specified password" 1>&2
  exit 1
fi
if [ -n "$ssh_port" ]; then
  echo "Not specified ssh-port" 1>&2
  exit 1
fi

# Localization: locale and time zone.
ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
hwclock --systohc --utc
apt-get -y install task-japanese
cat <<END > /etc/locale.gen
en_US.UTF-8 UTF-8
ja_JP.UTF-8 UTF-8
END
locale-gen
echo LANG=ja_JP.UTF-8 > /etc/locale.conf
export LANG=ja_JP.UTF-8

## setup mirror for Japan
#        Temporarily comment out in the U.S.
#cat <<END > /etc/apt/sources.list
#deb http://ftp.jp.debian.org/debian/ jessie main non-free contrib
#deb-src http://ftp.jp.debian.org/debian/ jessie main non-free contrib
#deb http://ftp.jp.debian.org/debian/ jessie-updates main non-free contrib
#deb-src http://ftp.jp.debian.org/debian/ jessie-updates main non-free contrib
#deb http://security.debian.org/ jessie/updates main non-free contrib
#deb-src http://security.debian.org/ jessie/updates main non-free contrib

#deb http://ftp.jp.debian.org/debian jessie-backports main contrib non-free
#deb-src http://ftp.jp.debian.org/debian jessie-backports main contrib non-free
#END

# setup non-root user
useradd -m -g wheel -s /bin/bash $user_name
echo 'Defaults env_keep += "HOME"' >> /etc/sudoers
echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers
echo $user_name:$password | chpassword

cat <<END >> /etc/ssh/sshd_config
# http://www.maruko2.com/mw/ssh_%E6%8E%A5%E7%B6%9A%E3%82%92%E3%82%BF%E3%82%A4%E3%83%A0%E3%82%A2%E3%82%A6%E3%83%88%E3%81%97%E3%81%AA%E3%81%84%E3%82%88%E3%81%86%E3%81%AB%E3%81%99%E3%82%8B
ClientAliveInterval 15

# setup ssh only for non-root user
#PermitRootLogin no
#Port $ssh_port
END

# packages I use everyday.
apt-get update
apt-get -y upgrade
apt-get -y install
  vim \
  git \
  tmux \
  silversearcher-ag
