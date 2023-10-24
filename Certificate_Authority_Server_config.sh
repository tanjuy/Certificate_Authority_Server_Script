#!/usr/bin/env bash

crt_to_host() {

        while :
        do
                read -p "Enter your disto [i.e: ubuntu, debain, rocky]: " distro

                case $distro in
                        ubuntu)
                                echo "Your distro is ubuntu"
                                read -p "Enter a target user[i.e: tanju]: " user
                                read -p 'Enter a target host[i.e: 192.168.1.6]: ' host
                                scp $easy_rsa/pki/ca.crt $user@$host:/usr/local/share/ca-certificates/
                                printf "Run command on the target host: ${magenta}${bold}sudo update-ca-certificates${normal}"
                                break
                                ;;                                                                                                                                                             rocky|centos)
                                echo 'Your distro is rocky'
                                read -p "Enter a target user[i.e: tanju]: " user
                                read -p 'Enter a target host[i.e: 192.168.1.6]: ' host
                                scp $easy_rsa/pki/ca.crt $user@$host:/etc/pki/ca-trust/\source/anchors/
                                printf "Run command on the target host: ${magenta}${bold}sudo update-ca-trust${normal}"
                                break
                                ;;
                        *)
                                echo '[ubuntu, rocky, centos]'
                esac
        done
}

# OpenVPN Server
import_cert_req() {
	easy_rsa='/home/$USER/easy-rsa'
	read -p "Write Common Name of your OpenVPN server: " oCN	
	read -p 'Write Path of your OpenVPN server [ /tmp/server.req ] : ' oPath	

	cd $easy_rsa
	$easy_rsa/easyrsa import-req $oPath $oCN
	
	$easy_rsa/easyrsa sign-req server $oCN
	
	read -p 'Enter user of your VPN server [tanju]: ' vpnUser
	read -p 'Enter IP of your VPN server [ 192.168.1.5 ]: ' vpnIP

	scp $easy_rsa/pki/issued/server.crt $vpnUser@$IP:/tmp
	scp $easy_rsa/pki/ca.crt $vpnUser@$IP:/tmp
}

printf "
	1-Distributing your Certificate Authority’s Public Certificate
	2-Signing the OpenVPN Server’s Certificate Request
	3-import the certificate request
\n"
read -p "Enter a number above range: " option

case $option in 
	1)
		echo "1"
		;;
	2)
		echo '2'
		;;
	*)
		echo 'Warmming'
esac


