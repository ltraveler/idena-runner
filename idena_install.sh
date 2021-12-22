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
echo -e "${LYELLOW}Please enter a user name and password that you would like to use for this ${LGREEN}Idena Node Daemon Instance${NC}"
# read -p "Enter username : " username

while
echo -e "Please do not use ${LGREEN}root${NC} as a username"
read -p "Enter username : " username
[[ $username = 'root' ]]
do true; done

read -s -p "Enter password : " password
if [ -f "/etc/systemd/system/idena_$username.service" ]
then
echo "The service is exists. Don't worry, I will kill it."
systemctl stop idena_$username
systemctl disable idena_$username
ipfsport=($(jq -r '.IpfsConf.IpfsPort' /home/$username/idena-go/config.json))
ufw delete allow ${ipfsport[0]}
rm /etc/systemd/system/idena_$username.service #killing the service
rm /usr/lib/systemd/system/idena_$username.service # and related symlinks
systemctl daemon-reload
systemctl reset-failed
else
   echo "Making clean IDENA Node Installation"
fi
#Firewall pre-chek
ufw disable
if compgen -G "/etc/systemd/system/idena*.service" > /dev/null; then
echo "Idena Service exists. I will keep UFW rules as it is."
else
    echo "Applying UFW deny incoming rules for the first idena node instance installation"
    ufw default deny incoming
fi
#in case if the user has been deleted and screen session still exists
chown $username:$username /run/screen/S-$username
#
# creating a user name and password for idena service 
#
if [ $(id -u) -eq 0 ]; then
	egrep "^$username" /etc/passwd >/dev/null
	if [ $? -eq 0 ]; then
		echo "$username exists! Let's kill existed idena installation."
        rm -r /home/$username/idena-go
        rm -f /etc/cron.d/idena_update_$username 
        pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
        usermod --password $pass $username
        grep -q "$username ALL=NOPASSWD: /usr/sbin/service idena_$username *" /etc/sudoers || echo "$username ALL=NOPASSWD: /usr/sbin/service idena_$username *" >> /etc/sudoers
	else
		pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
		useradd -s /bin/bash -m -p $pass $username
		[ $? -eq 0 ] && echo "User has been added to system!" || echo "Failed to add a user!"
#add only if sudoers record doesn't exist 
        grep -q "$username ALL=NOPASSWD: /usr/sbin/service idena_$username *" /etc/sudoers || echo "$username ALL=NOPASSWD: /usr/sbin/service idena_$username *" >> /etc/sudoers 
	fi
else
	echo "Only root may add a user to the system"
	exit 2
fi
#
#updating Ubuntu and installing all required dependencies
apt-get update
apt-get upgrade -y
apt-get install -y jq git ufw curl wget nano screen psmisc unzip
#
mkdir /home/$username/idena-go
#cd /home/$username/idena-go  
#downloading specific version or the latest one
read -p "Enter the number of the idena-go version (eg. 0.18.2) keep it empty to download the latest one: " version
if [ -z $version ]; then version=$(curl -s https://api.github.com/repos/idena-network/idena-go/releases/latest | grep -Po '"tag_name":.*?[^\\]",' | sed 's/"tag_name": "v//g' |  sed 's/",//g') ; echo Installing version $version; fi
touch /home/$username/idena-go/version
echo "$version" > /home/$username/idena-go/version
wget https://github.com/idena-network/idena-go/releases/download/v$version/idena-node-linux-$version
#customize config.json
while true; do
    read -p "If you are installing multiple instances of Idena Node, you have to change default ports in config.json file. Would you like to do so?" yn
    case $yn in
        [Yy]* ) nano config.json; break;; 
        [Nn]* ) echo "Using default config.json file"; break;;
        * ) echo "Please answer yes or no.";;
    esac
done
#copying config.json and idena.service
cp {config.json,idena.service} /home/$username/idena-go
mv idena-node-linux-$version /home/$username/idena-go/idena-node
chown -R $username:$username /home/$username/idena-go
#checking if ipfs port is opened
ipfsport=($(jq -r '.IpfsConf.IpfsPort' /home/$username/idena-go/config.json))
until ! nc -zv localhost $ipfsport; do
echo IPFS port is already used. Please choose another one.; read -p "Press enter to edit config.json file"; nano /home/$username/idena-go/config.json; 
ipfsport=($(jq -r '.IpfsConf.IpfsPort' /home/$username/idena-go/config.json))
done
#checking if rpc port is opened
rpcport=($(jq -r '.RPC.HTTPPort' /home/$username/idena-go/config.json))
until ! nc -zv localhost $rpcport; do
echo RPC port is already used. Please choose another one.; read -p "Press enter to edit config.json file"; nano /home/$username/idena-go/config.json;
rpcport=($(jq -r '.RPC.HTTPPort' /home/$username/idena-go/config.json))
done
#iDNA blockchain bootstrp mirrors
dnabc="https://sync.idena.site/idenachain.db.zip"
dnabc1="https://sync.idena-ar.com/idenachain.db.zip"
dnabc2="https://github.com/ltraveler/idenachain.db.git"
function validate_url()
{
    wget --spider $1
    return $?
}
mkdir /home/$username/idena-go/datadir ; mkdir /home/$username/idena-go/datadir/idenachain.db
chown -R $username:$username /home/$username/idena-go/datadir
if validate_url $dnabc2; then echo -e "${YELLOW}Downloading IDENA blockchain bootstrap: GitHub${NC}" ; rm -rf /home/$username/idena-go/datadir/idenachain.db ; git clone -b main --depth 1 --single-branch $dnabc2 /home/$username/idena-go/datadir/idenachain.db && rm -rf /home/$username/idena-go/datadir/idenachain.db/.git; elif validate_url $dnabc; then echo -e "${YELLOW}Downloading IDENA blockchain bootstrap: Mirror 01${NC}" &&  rm -rf /home/$username/idena-go/datadir/idenachain.db && wget --directory-prefix=/home/$username/idena-go/datadir $dnabc && unzip /home/$username/idena-go/datadir/idenachain.db.zip -d /home/$username/idena-go/datadir && rm -f /home/$username/idena-go/datadir/idenachain.db.zip; elif validate_url $dnabc1; then echo -e "${YELLOW}Downloading IDENA blockchain bootstrap: Mirror 2${NC}" && rm -rf /home/$username/idena-go/datadir/idenachain.db &&  wget --directory-prefix=/home/$username/idena-go/datadir $dnabc1 && unzip /home/$username/idena-go/datadir/idenachain.db.zip -d /home/$username/idena-go/datadir && rm -f /home/$username/idena-go/datadir/idenachain.db.zip; else echo "IDENA blockchain mirror is not available"; fi;
#Changing idenachain rights
chown -R $username:$username /home/$username/idena-go
#Continue as username
sudo -i -u $username bash << EOF
whoami
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
echo -e ${LBLUE}Your IDENA-node API key is: ${YELLOW}$apikey
prvkey=$( cat /home/$username/idena-go/datadir/keystore/nodekey )
echo -e ${LBLUE}Your IDENA-node PRIVATE key is: ${YELLOW}$prvkey${NC}

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
cp /home/$username/idena-go/idena.service /etc/systemd/system/idena_$username.service
systemctl start idena_$username.service
systemctl enable idena_$username.service
#Checking for idena updates ones a day
cp idena_insp.sh /home/$username/idena-go/idena_insp_$username.sh
chown $username:$username /home/$username/idena-go/idena_insp_$username.sh
read -p $'\e[33m\e[1mPlease insert the frequency \e[32m\e[1m in cron schedule expressions format \e[0mwhen the script will be checking for updates. \n\e[31m\e[1mEmpty prompt will set the value to run it once a day at 1AM:\e[0m ' idupdate
if [[ -z $idupdate ]]; then idupdate=$(echo "0 1 * * *") ; echo "Set as default $idupdate"; fi
echo "$idupdate $username bash /home/$username/idena-go/idena_insp_$username.sh" > /etc/cron.d/idena_update_$username
#crontab -l | grep -q "idena_insp_$username"  && echo 'entry exists' || (crontab -l 2>/dev/null; echo "$idupdate /home/$username/idena-go/idena_insp_$username.sh") | crontab -
# ufw configuration
SSHPORT=${SSH_CLIENT##* }
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

