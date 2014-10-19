#!/bin/bash

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
