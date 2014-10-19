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
