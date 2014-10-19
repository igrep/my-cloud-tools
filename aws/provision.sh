#!/bin/bash

ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
hwclock --systohc --utc

cat <<END > /etc/locale.gen
en_US.UTF-8 UTF-8
ja_JP.UTF-8 UTF-8
END
locale-gen
echo LANG=ja_JP.UTF-8 > /etc/locale.conf
export LANG=ja_JP.UTF-8

cat <<END > /etc/pacman.d/mirrorlist
## Score: 1.6, Japan
Server = http://ftp.jaist.ac.jp/pub/Linux/ArchLinux/\$repo/os/\$arch
## Score: 1.8, Japan
Server = http://ftp.tsukuba.wide.ad.jp/Linux/archlinux/\$repo/os/\$arch
END

# TODO: setup non-root user with password and PermitRootLogin no
cat <<'COMMENT_OUT'
useradd -m -g users -G wheel -s /bin/bash $user_name
cat <<END >> /etc/ssh/sshd_config
# http://www.maruko2.com/mw/ssh_%E6%8E%A5%E7%B6%9A%E3%82%92%E3%82%BF%E3%82%A4%E3%83%A0%E3%82%A2%E3%82%A6%E3%83%88%E3%81%97%E3%81%AA%E3%81%84%E3%82%88%E3%81%86%E3%81%AB%E3%81%99%E3%82%8B
ClientAliveInterval 15

PermitRootLogin no
Port $ssh_port
END
COMMENT_OUT

pacman -Syu --noconfirm
pacman -R --noconfirm vim # avoid conflict
pacman -S --noconfirm \
  vim-python3 \
  git \
  tmux \
  the_silver_searcher \
  dstat \
  ghc cabal-install haddock happy alex
  #vim-runtime \ # avoid to reinstall
  #ruby \ # avoid to reinstall. it's one of the dependencies of vim-python3.
