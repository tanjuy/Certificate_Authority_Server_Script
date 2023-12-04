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

# Variables;
easy_rsa="/home/$USER/easy-rsa"

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
# To create a skeleton Public Key Infrastructure (PKI) on the CA Server.
echo 'creating the easy-rsa directory...'
sleep 1
if [ -d "$easy_rsa" ]; then
	echo "$easy_rsa have already existed!"
else 
	mkdir $easy_rsa
	echo "$easy_rsa created!"
fi

# To use this directory to create symbolic links pointing to the easy-rsa package files that we’ve installed in the previous step.
:<< test_command_alternative
if [[    # ------------------------------->   This is same as below if [  ] that is, test command
	-h "$easy_rsa/easyrsa" &&
	-L "$easy_rsa/openssl-easyrsa.cnf"
   ]]; then
test_command_alternative

if [ -h "$easy_rsa/easyrsa" -a -h "$easy_rsa/openssl-easyrsa.cnf" ]; then
	echo "A symlink have already created with $easy_rsa"
else
	ln -s /usr/share/easy-rsa/* ${easy_rsa}
	sleep 1
	echo "/usr/share/easy-rsa/*   ------>   ${easy_rsa} (symlinked)"
fi

# To restrict access to your new PKI directory
chmod 700 ${easy_rsa}
cd ${easy_rsa}
bash $easy_rsa/easyrsa init-pki

# Step 3 — Creating a Certificate Authority
echo 'Fill each prompt to reflect your own organization info.'
echo 'The important part here is to ensure that you do not leave any of the values blank'
read -p "Enter a Country: " country
sed "s/^#set_var EASYRSA_REQ_COUNTRY\t\"US\"/set_var EASYRSA_REQ_COUNTRY\t\"${country}\"/" $easy_rsa/vars.example > $easy_rsa/vars
read -p 'Enter a Province: ' province
sed -i "s/^#set_var EASYRSA_REQ_PROVINCE\t\"California\"/set_var EASYRSA_REQ_PROVINCE\t\"${province}\"/" $easy_rsa/vars
read -p 'Enter a City: ' city
sed -i "s/^#set_var EASYRSA_REQ_CITY\t\"San Francisco\"/set_var EASYRSA_REQ_CITY\t\"${city}\"/" $easy_rsa/vars
read -p 'Enter a Organization: ' org
sed -i "s/^#set_var EASYRSA_REQ_ORG\t\"Copyleft Certificate Co\"/set_var EASYRSA_REQ_CITY\t\"${org}\"/" $easy_rsa/vars
read -p 'Enter a Email: ' email
sed -i "s/^#set_var EASYRSA_REQ_EMAIL\t\"me@example.net\"/set_var EASYRSA_REQ_CITY\t\"${email}\"/" $easy_rsa/vars
read -p 'Enter a Organizational Unit: ' OU
sed -i "s/^#set_var EASYRSA_REQ_OU\t\t\"My Organizational Unit\"/set_var EASYRSA_REQ_CITY\t\"${OU}\"/" $easy_rsa/vars

sed -i 's/^#set_var EASYRSA_ALGO\t\trsa/set_var EASYRSA_ALGO\t\t"ec"/' $easy_rsa/vars
sed -i 's/^#set_var EASYRSA_DIGEST\t\t"sha256"/set_var EASYRSA_DIGEST\t\t"sha512"/' $easy_rsa/vars

echo "To create the root public and private key pair for your Certificate Authority"
printf "In the output, you’ll see some lines about the OpenSSL version and you will be prompted to enter a passphrase for your key pair. 
Be sure to choose a strong passphrase, and note it down somewhere safe. You will need to input the passphrase any time that you need to
interact with your CA, for example to sign or revoke a certificate."
# read -p 'Write "nopass" for no-password or just press enter for password: ' nop
# bash $easy_rsa/easyrsa build-ca $nop
bash $easy_rsa/easyrsa build-ca nopass

# Step 4 -  Buradan yukarsı test edildi..........
