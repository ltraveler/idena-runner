#!/bin/bash
#
#ASCII color assign
RED="\033[0;31m"
LRED="\033[1;31m"
YELLOW="\033[0;33m"
LYELLOW="\033[1;33m"
GREEN="\033[0;32m"
LGREEN="\033[1;32m"
BLUE="\033[0;34m"
LBLUE="\033[1;34m"
PURPLE="\033[0;35m"
LPURPLE="\033[1;35m"
CYAN="\033[0;36m"
LCYAN="\033[1;36m"
NC="\033[0m" # No Color
#Checking if the idena service exists.
if [ -f "/etc/systemd/system/idena.service" ]
then
echo "The service is exists. Don't worry, I will kill it."
systemctl stop idena
systemctl disable idena
rm /etc/systemd/system/idena.service #killing the service
rm /usr/lib/systemd/system/idena.service # and related symlinks
systemctl daemon-reload
systemctl reset-failed
else
   echo "Making clean IDENA Node Installation"
fi
#
# creating a user name and password for idena service 
#
if [ $(id -u) -eq 0 ]; then
	read -p "Enter username : " username
	read -s -p "Enter password : " password
	egrep "^$username" /etc/passwd >/dev/null
	if [ $? -eq 0 ]; then
		echo "$username exists!"
		exit 1
	else
		pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
		useradd -s /bin/bash -m -p $pass $username
		[ $? -eq 0 ] && echo "User has been added to system!" || echo "Failed to add a user!"
	fi
else
	echo "Only root may add a user to the system"
	exit 2
fi
#
#updating Ubuntu and installing all required dependencies
apt-get update
apt-get upgrade -y
apt-get install -y jq git ufw npm wget nano screen psmisc unzip
#
mkdir /home/$username/idena-go
cd idena-go
#downloading specific version or the latest one
read -p "Enter the number of the idena-go version (eg. 0.18.2) keep it empty to download the latest one: " version
if [ -z $version ]; then version=$(curl -s https://api.github.com/repos/idena-network/idena-go/releases/latest | grep -Po '"tag_name":.*?[^\\]",' | sed 's/"tag_name": "v//g' |  sed 's/",//g') ; echo Installing version $version; fi
touch /home/$username/idena-go/version
echo "$version" > /home/$username/idena-go/version
wget https://github.com/idena-network/idena-go/releases/download/v$version/idena-node-linux-$version
#customize config.json
while true; do
    read -p "Would you like to edit default config.json file?" yn
    case $yn in
        [Yy]* ) nano config.json; break;; 
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done
#copying config.json and idena.service
cp {config.json,idena.service} /home/$username/idena-go
mv idena-node-linux-$version /home/$username/idena-go/idena-node
chown -R $username:$username /home/$username/idena-go
#Continue as username
sudo -i -u $username bash << EOF
whoami
cd ~/idena-go
mkdir datadir ; mkdir datadir/idenachain.db
cd datadir/idenachain.db
wget https://sync.idena.site/idenachain.db.zip
unzip idenachain.db.zip
rm idenachain.db.zip
cd ~/idena-go
#
chmod +x idena-node
screen -d -m bash -c "/home/$username/idena-go/./idena-node --config=config.json"
echo Idena-node has been installed succesfully

until [ -s ~/idena-go/datadir/api.key ]
do
     sleep 5
done

until [ -s ~/idena-go/datadir/keystore/nodekey ]
do
     sleep 5
done

EOF

apikey=$( sudo -i -u $username cat /home/$username/idena-go/datadir/api.key )
echo Your IDENA-node API key is: $apikey
prvkey=$( cat /home/$username/idena-go/datadir/keystore/nodekey )
echo Your IDENA-node PRIVATE key is: $prvkey

#If yes changing prv and api keys
while true; do
    read -p "Would you like to add your own IDENA private key?" yn
    case $yn in
        [Yy]* ) killall screen; read -p "Please enter your IDENA private key: "; echo "$REPLY" > /home/$username/idena-go/datadir/keystore/nodekey; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

while true; do
    read -p "Would you like to add your own IDENA node key?" yn
    case $yn in
        [Yy]* ) killall screen > /dev/null 2>&1; read -p "Please enter your IDENA node key: "; echo "$REPLY" > /home/$username/idena-go/datadir/api.key; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

# kill screen before to create the idena daemon
killall screen
# creating idena daemon
sed -i "s/\$username/${username}/g" /home/$username/idena-go/idena.service
cp /home/$username/idena-go/idena.service /etc/systemd/system/
systemctl start idena.service
systemctl enable idena.service
#Checking for idena updates ones a day
cp idena_insp.sh /home/$username/idena-go/
chown $username:$username /home/$username/idena-go/idena_insp.sh
read -p "Please insert the frequency in cron schedule expressions format when the script will be checking for updates. Empty prompt will set the value to once a day at 1AM: " idupdate
if [[ -z $idupdate ]]; then idupdate=$(echo "0 1 * * *") ; echo "Set as default $idupdate"; fi
crontab -l | grep -q 'idena_insp'  && echo 'entry exists' || (crontab -l 2>/dev/null; echo "$idupdate /home/$username/idena-go/idena_insp.sh") | crontab -
# ufw configuration
SSHPORT=${SSH_CLIENT##* }
ufw disable
ufw default deny incoming
ufw allow $SSHPORT
ufw allow "OpenSSH"
ipfsport=($(jq -r '.IpfsConf.IpfsPort' /home/$username/idena-go/config.json))
ufw allow ${ipfsport[0]}
sudo ufw enable
sudo ufw status
# Installation has been successfully completed
echo -e "${LRED}IDENA NODE HAS BEEN SUCCESSFULLY INSTALLED" 
echo -e "${LGREEN}FOR IDENA DONATIONS:${NC} 0xf041640788910fc89a211cd5bcbf518f4f14d831"
echo -e "${YELLOW}CONTACT AUTHOR:${NC} ltraveler@protonmail.com"
echo -e "${LBLUE}IDENA PERSONALIZED SHARED NODE SERVICE:${NC} https://t.me/ltrvlr"
exit

