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
#input flags set
set -o pipefail -o nounset -o noclobber  #-o errexit 

! getopt --test > /dev/null 
if [[ ${PIPESTATUS[0]} -ne 4 ]]; then
    echo 'I’m sorry, `getopt --test` failed in this environment.'
    exit 1
fi

OPTIONS=u:p:v:sb:f:l:r:i:k:a:d: # man getopt explains what this : means
LONGOPTS=username,password,version:,shared,blockpinthreshold,flippinthreshold,allflipsloadingtime,rpcport,ipfsport,privatekey,apikey,updatefreq

! PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTS --name "$0" -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    exit 2
fi
# 
eval set -- "$PARSED"
username='n' password='n' version='n' shared_node='n' bp_threshold='0.3' fp_threshold='1' af_time='7200000000000' nrpcport='n' nipfsport='n' privatekey='n' nodeapikey='n' idupdate='n' 
if [ "$shared_node" = "true" ]; then
echo 'incorrect argument for ${LYELLOW}-s${NC} | ${LYELLOW}--shared ${NC}flag'
fi
# 
while true; do
    case "$1" in
        -u|--user)
            username="$2"
            shift 2
            ;;
        -p|--password)
            password="$2"
            shift 2
            ;;
        -s|--shared)
            shared_node=yes
            shift
            ;;
        -v|--version)
            version="$2"
            shift 2
            ;;
        -b|--blockpinthreshold)
            bp_threshold="$2"
            shift 2
            ;;
        -f|--flippinthreshold)
            fp_threshold="$2"
            shift 2
            ;;
        -l|--allflipsloadingtime)
            af_time="$2"
            shift 2
            ;;
        -r|--rpcport)
            nrpcport="$2"
            shift 2
            ;;
        -i|--ipfsport)
            nipfsport="$2"
            shift 2
            ;;
        -k|--privatekey)
            privatekey="$2"
            shift 2
            ;;
        -a|--apikey)
            nodeapikey="$2"
            shift 2
            ;;
        -d|--updatefreq)
            idupdate="$2"
            shift 2
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Programming error"
            exit 3
            ;;
    esac
done
#password the same as username if password not specified 
if [[ "$username" != 'n' && -z "$password" ]]; then
password="$username"
fi
#updating Ubuntu and installing all required dependencies
apt-get update
apt-get upgrade -y
reqpkgs=('jq' 'git' 'ufw' 'curl' 'wget' 'nano' 'screen' 'psmisc' 'unzip')
for x in "${reqpkgs[@]}"; do
dpkg -s "$x" &> /dev/null
if [ $? != 0 ]; then
    echo -e "${LRED}Package $x is not instlled. Installing...${NC}"
    apt-get install -y $x; 
#
fi
done
#
echo -e "${LYELLOW}Please enter a ${LRED}username${NC} and ${LRED}password${LYELLOW} that you would like to use for this ${LGREEN}Idena Node Daemon${LYELLOW} instance.${NC}"
# read -p "Enter username : " username
if [ "$username" = 'n' ]; then
while
echo -e "${NC}Please do not use ${LGREEN}root${NC} as a username"
read -p "Enter username : " username
[[ $username = 'root' ]]
do true; done

read -s -p "Enter password : " password
fi
#adding user to DenyUsers group
a_users=$(grep 'DenyUsers' /etc/ssh/sshd_config) 
if [ -z "$a_users" ]; then
    echo "User is not in the DenyUsers group"
    echo "User has been added to DenyUsers group"
    echo "DenyUsers $username" >> /etc/ssh/sshd_config
elif
    echo "$a_users" | grep -w "$username"; then
    echo "User already in DenyUsers list"
else
    a_users="$a_users $username"
    sed -i.bak "/DenyUsers/c$a_users" /etc/ssh/sshd_config
    echo "User has been added to DenyUsers group"
fi
service ssh restart
#Overwriting config.json to the default one from the repository to prevent possible conflicts
curl https://raw.githubusercontent.com/ltraveler/idena-runner/main/config.json >| config.json
#Are we installing a shared node?
if [ "$shared_node" = 'n' ]; then
while true; do
    read -p "$(echo -e ${LYELLOW}Would you like to install your idena node as a shared node? ${LGREEN}[y/N]${NC} )" yn
    case $yn in
        [Yy]* ) shared_node="true" && sed -i '/ExecStart/cExecStart=\/home\/$username\/idena-go\/idena-node --config=\/home\/$username\/idena-go\/config.json --profile=shared' idena.service && echo "Shared node installation"; break;; 
        [Nn]* ) sed -i 's/ --profile=shared//g' idena.service && echo "Regular node installation"; break;;
        * ) echo "Please answer yes or no.";;
    esac
done
else
    sed -i '/ExecStart/cExecStart=\/home\/$username\/idena-go\/idena-node --config=\/home\/$username\/idena-go\/config.json --profile=shared' idena.service && echo "Shared node installation" 
    sed -i -e "/BlockPinThreshold/c\    \"BlockPinThreshold\": $bp_threshold," -e "/FlipPinThreshold/c\    \"FlipPinThreshold\": $fp_threshold" -e "/AllFlipsLoadingTime/c\    \"AllFlipsLoadingTime\": $af_time," config.json; 
fi
#If shared true 
if [ "$shared_node" = "true" ]; then
while true; do
    read -p "$(echo -e ${LYELLOW}Would you like to set ${LRED}default recommended values${LYELLOW} in the shared node configuration file? ${LGREEN}[y/N]${NC} )" yn
    case $yn in
        [Yy]* ) echo -e "${LGREEN}Let's optimize shared node configuration file ${LYELLOW}by setting default values of\n${LRED}BlockPinThreshold: ${GREEN}-0.3${NC};\n${LRED}FlipPinThreshold: ${LGREEN}-1${NC};\n${LRED}AllFlipsLoadingTime: ${GREEN}-7200000000000${NC};" && bp_threshold=${bp_threshold:-0.3} && fp_threshold=${fp_threshold:-1} && af_time=${af_time:-7200000000000} && sed -i -e "/BlockPinThreshold/c\    \"BlockPinThreshold\": $bp_threshold," -e "/FlipPinThreshold/c\    \"FlipPinThreshold\": $fp_threshold" -e "/AllFlipsLoadingTime/c\    \"AllFlipsLoadingTime\": $af_time," config.json; break;;
        [Nn]* ) echo -e "${LGREEN}Let's optimize our shared node configuration file.${NC}\n${LRED}If you don't know the meaning of the following args, please skip them by pressing ENTER.${NC}\n${LGREEN}That will set the value to the default recommended one. You can see it inside the square brackets.${NC}" && read -p "$(echo -e ${LRED}BlockPinThreshold ${NC}[${LGREEN}0.3${NC}]: )" bp_threshold && bp_threshold=${bp_threshold:-0.3} && read -p "$(echo -e ${LRED}FlipPinThreshold ${NC}[${LGREEN}1${NC}]: )" fp_threshold && fp_threshold=${fp_threshold:-1} && read -p "$(echo -e ${LRED}AllFlipsLoadingTime ${NC}[${LGREEN}7200000000000${NC}]: )" af_time && af_time=${af_time:-7200000000000} && echo $bp_threshold && echo $fp_threshold && echo $af_time && sed -i -e "/BlockPinThreshold/c\    \"BlockPinThreshold\": $bp_threshold," -e "/FlipPinThreshold/c\    \"FlipPinThreshold\": $fp_threshold" -e "/AllFlipsLoadingTime/c\    \"AllFlipsLoadingTime\": $af_time," config.json; break;;
        * ) echo -e "${GREEN}Please answer yes or no.${NC}";;
    esac
done
fi
#checking if there is any idena daemon related to the inserted user
if [ -f "/etc/systemd/system/idena_$username.service" ]
then
echo "The service is exists. Don't worry, I will kill it."
systemctl stop idena_$username
systemctl disable idena_$username
ipfsport=($(jq -r '.IpfsConf.IpfsPort' /home/$username/idena-go/config.json))
ufw delete allow ${ipfsport[0]}
rm /etc/systemd/system/idena_$username.service ||: #killing the service
rm /usr/lib/systemd/system/idena_$username.service ||: # and related symlinks
systemctl daemon-reload
systemctl reset-failed
else
   echo "Making clean IDENA Node Installation"
fi
#Firewall precheck
ufw disable
if compgen -G "/etc/systemd/system/idena*.service" > /dev/null; then
echo "Idena Service exists. I will keep UFW rules as it is."
else
    echo "Applying UFW deny incoming rules for the first idena node instance installation"
    ufw default deny incoming
fi
#in case if the user has been deleted and screen session still exists
if pgrep screen &> /dev/null ; then sudo killall screen ; fi
#chown $username:$username /run/screen/S-$username
#
# creating a user name and password for idena service 
#
if [ "$(id -u)" -eq 0 ]; then
	egrep -w "$username" /etc/passwd > /dev/null
	if [ $? -eq 0 ]; then
		echo "$username exists! Let's kill existed idena installation."
        rm -r /home/$username/idena-go ||:
        rm -f /etc/cron.d/idena_update_$username ||:
        pass=$(openssl passwd -crypt $password)
        usermod --password $pass $username
        grep -q "$username ALL=NOPASSWD: /usr/sbin/service idena_$username *" /etc/sudoers || echo "$username ALL=NOPASSWD: /usr/sbin/service idena_$username *" >> /etc/sudoers
	else
        pass=$(openssl passwd -crypt $password)
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

mkdir /home/$username/idena-go
#cd /home/$username/idena-go  
#downloading specific version or the latest one
if [ "$version" = 'latest'  ]; then version=$(curl -s https://api.github.com/repos/idena-network/idena-go/releases/latest | grep -Po '"tag_name":.*?[^\\]",' | sed 's/"tag_name": "v//g' |  sed 's/",//g') ; echo Installing version $version; fi 
if [ "$version" = 'n'  ]; then read -p "$(echo -e ${LYELLOW}Enter the number of the idena-go version \(eg. ${LRED}0.18.2\)${LYELLOW} ${LGREEN}keep it empty ${LYELLOW}to download the latest one:${NC} )" version; fi
if [ -z $version ]; then version=$(curl -s https://api.github.com/repos/idena-network/idena-go/releases/latest | grep -Po '"tag_name":.*?[^\\]",' | sed 's/"tag_name": "v//g' |  sed 's/",//g') ; echo Installing version $version; fi
touch /home/$username/idena-go/version
echo "$version" >| /home/$username/idena-go/version
wget https://github.com/idena-network/idena-go/releases/download/v$version/idena-node-linux-$version
#customize config.json

if [[ "$nrpcport" = 'n' && "$nipfsport" != 'n' ]]; then
    read -p "$(echo -e ${LRED}HTTP Port ${LYELLOW}aka ${LRED}RPC Port ${NC}[${LGREEN}9009${NC}]: )" nrpcport && nrpcport=${nrpcport:-9009}
    sed -i -e "/HTTPPort/c\    \"HTTPPort\": $nrpcport" -e "/IpfsPort/c\    \"IpfsPort\": $nipfsport," config.json
elif [[ "$nipfsport" = 'n' && "$nrpcport" != 'n' ]]; then
    read -p "$(echo -e ${LRED}IPFS Port ${NC}[${LGREEN}40405${NC}]: )" nipfsport && nipfsport=${nipfsport:-40405}
    sed -i -e "/IpfsPort/c\    \"IpfsPort\": $nipfsport," -e "/HTTPPort/c\    \"HTTPPort\": $nrpcport" config.json
elif [[ "$nipfsport" != 'n' && "$nrpcport" != 'n' ]]; then
    sed -i -e "/HTTPPort/c\    \"HTTPPort\": $nrpcport" -e "/IpfsPort/c\    \"IpfsPort\": $nipfsport," config.json
else
while true; do
    read -p "$(echo -e ${LYELLOW}If you are installing multiple instances of Idena Node, ${LRED}you have to change default ports in ${LGREEN}config.json ${LRED}file. ${LYELLOW}Would you like to do so? ${LGREEN}[y/N]${NC})" yn
    case $yn in
        [Yy]* ) nano config.json; break;; 
        [Nn]* ) echo "Using default config.json file"; break;;
        * ) echo "Please answer yes or no.";;
    esac
done
fi
    
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

apikey=$( cat /home/$username/idena-go/datadir/api.key )
if [ "$nodeapikey" != 'n' ]; then
apikey="$nodeapikey"
( sudo -i -u $username echo "$apikey" >| /home/$username/idena-go/datadir/api.key )
fi
echo -e ${LBLUE}Your IDENA-node API key is: ${YELLOW}$apikey
prvkey=$( cat /home/$username/idena-go/datadir/keystore/nodekey )
if [ "$privatekey" != 'n' ]; then
prvkey="$privatekey"
( sudo -i -u $username echo "$prvkey" >| /home/$username/idena-go/datadir/keystore/nodekey ) 
fi
echo -e ${LBLUE}Your IDENA-node PRIVATE key is: ${YELLOW}$prvkey${NC}

#If yes changing prv and api keys

if [[ "$privatekey" = 'n' && "$nodeapikey" = 'n' ]]; then
while true; do
    read -p "$(echo -e ${LYELLOW}Would you like to add your own ${LGREEN}IDENA NODE PRIVATE KEY${LYELLOW} \(aka ${LRED}nodekey${LYELLOW}\)?$'\n'${LGREEN}Default path: ${LRED}../idena-go/datadir/keystore/nodekey ${LGREEN}[y/N]${NC} )" yn
    case $yn in
        [Yy]* ) killall screen; read -p "$(echo -e ${LYELLOW}Please enter your IDENA private key:${NC} )"; echo "$REPLY" > /home/$username/idena-go/datadir/keystore/nodekey; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

while true; do
    read -p "$(echo -e ${LYELLOW}Would you like to add your own ${LGREEN}IDENA NODE API KEY${LYELLOW} \(aka ${LRED}api.key${LYELLOW}\)?$'\n'${LGREEN}Default path: ${LRED}../idena-go/datadir/api.key  ${LGREEN}[y/N]${NC} )" yn
    case $yn in
        [Yy]* ) killall screen > /dev/null 2>&1; read -p "$(echo -e ${LYELLOW}Please enter your IDENA node key: ${NC})"; echo "$REPLY" > /home/$username/idena-go/datadir/api.key; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done
fi
if [[ "$privatekey" = 'n' && "$nodeapikey" != 'n' ]]; then
while true; do
    read -p "$(echo -e ${LYELLOW}Would you like to add your own ${LGREEN}IDENA NODE PRIVATE KEY${LYELLOW} \(aka ${LRED}nodekey${LYELLOW}\)?$'\n'${LGREEN}Default path: ${LRED}../idena-go/datadir/keystore/nodekey ${LGREEN}[y/N]${NC} )" yn
    case $yn in
        [Yy]* ) killall screen > /dev/null 2>&1; read -p "$(echo -e ${LYELLOW}Please enter your IDENA private key:${NC} )"; echo "$REPLY" >| /home/$username/idena-go/datadir/keystore/nodekey; echo "$nodeapikey" >| /home/$username/idena-go/datadir/api.key; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done
fi
if [[ "$nodeapikey" = 'n' && "$privatekey" != 'n' ]]; then
while true; do
    read -p "$(echo -e ${LYELLOW}Would you like to add your own ${LGREEN}IDENA NODE API KEY${LYELLOW} \(aka ${LRED}api.key${LYELLOW}\)?$'\n'${LGREEN}Default path: ${LRED}../idena-go/datadir/api.key  ${LGREEN}[y/N]${NC} )" yn
    case $yn in
        [Yy]* ) killall screen > /dev/null 2>&1; read -p "$(echo -e ${LYELLOW}Please enter your IDENA node key: ${NC})"; echo "$REPLY" >| /home/$username/idena-go/datadir/api.key; echo "$privatekey" >| /home/$username/idena-go/datadir/keystore/nodekey; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done
fi
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
if [ "$idupdate" = 'n' ]; then
read -p $'\e[33mPlease insert \e[32mthe frequency \e[91m in cron schedule expressions format \e[33mwhen the script will be checking for updates. \n\e[31m\e[1mEmpty prompt \e[33mwill set the value to run it \e[32monce a day at 1AM:\e[0m ' idupdate
if [[ -z $idupdate ]]; then idupdate=$(echo "0 1 * * *") ; echo "Set as default $idupdate"; fi
fi    
echo "$idupdate $username bash /home/$username/idena-go/idena_insp_$username.sh" > /etc/cron.d/idena_update_$username
#crontab -l | grep -q "idena_insp_$username"  && echo 'entry exists' || (crontab -l 2>/dev/null; echo "$idupdate /home/$username/idena-go/idena_insp_$username.sh") | crontab -
# ufw configuration
SSHPORT=${SSH_CLIENT##* }
ufw allow $SSHPORT
ufw allow "OpenSSH"
ipfsport=($(jq -r '.IpfsConf.IpfsPort' /home/$username/idena-go/config.json))
ufw allow ${ipfsport[0]}
echo "y" | sudo ufw enable
#sudo ufw status
# Installation has been successfully completed
echo -e "${LRED}IDENA NODE HAS BEEN SUCCESSFULLY INSTALLED" 
echo -e "${LGREEN}FOR IDENA DONATIONS:${NC} 0xf041640788910fc89a211cd5bcbf518f4f14d831"
echo -e "${YELLOW}CONTACT AUTHOR:${NC} ltraveler@protonmail.com"
echo -e "${LBLUE}IDENA PERSONALIZED SHARED NODE SERVICE:${NC} https://t.me/ltrvlr"
exit
