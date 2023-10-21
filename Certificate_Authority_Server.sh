#!/usr/bin/env bash

# https://www.digitalocean.com/community/tutorials/how-to-set-up-and-configure-a-certificate-authority-ca-on-ubuntu-20-04#step-4-distributing-your-certificate-authority-s-public-certificate
# A Certificate Authority (CA) is an entity responsible for issuing digital certificates to verify identities on the internet. 

# To color font
if [ -t 1 ]; then    # if terminal
  ncolors=$(which tput > /dev/null && tput colors)  # support color
  # if test -n "$ncolors" && [ $ncolors -ge 8 ]; then
  if [ -n "$ncolors" ] && [ $ncolors -ge 8 ]; then  # bir önceki satırın aynısı
    termCols=$(tput cols)      # termanal genişliğini verecektir
    bold=$(tput bold)          # terminal yazısını bold yapar
    underline=$(tput smul)     # terminal yazısının altını çizer
    standout=$(tput smso)      # terminal'de arka temaları tersine çevirir
    normal=$(tput sgr0)        # terminal'li başlangıç değerine döndürür
    black="$(tput setaf 0)"    # terminal yazısını siyah yapar
    red="$(tput setaf 1)"      # terminal yazısını kırmızı yapar
    green="$(tput setaf 2)"    # terminal yazısını yeşil yapar
    yellow="$(tput setaf 3)"   # terminal yazısını sarı yapar
    blue="$(tput setaf 4)"     # terminal yazısını mavi yapar
    magenta="$(tput setaf 5)"  # terminal yazısını magenta yapar
    cyan="$(tput setaf 6)"     # terminal yazısını cyan yapar
    white="$(tput setaf 7)"    # terminal yazısını beyaz yapar
  fi
fi


echo "${bold}${yellow}System will be updated${normal}"
sleep 2
sudo apt update
echo "easy-rsa package and depends will be installed for Certificate Authority Infastructure"
sleep 2
# easy-rsa is a Certificate Authority management tool that you will use to generate a private key, and public root certificate,
#  which you will then use to sign requests from clients and servers that will rely on your CA.
sudo apt install easy-rsa

# step 2;
# Preparing a Public Key Infrastructure Directory

