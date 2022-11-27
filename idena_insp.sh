#!/bin/bash
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
NC="\033[0m"
latver=$( curl -s https://api.github.com/repos/idena-network/idena-go/releases/latest | grep -Po '"tag_name":.*?[^\\]",' | sed 's/"tag_name": "v//g' |  sed 's/",//g' ) 
username="$(whoami)"
version=$( cat /home/$username/idena-go/version )
echo $latver
echo $username
echo $version
lver=$( echo $latver | sed 's/[^0-9]*//g' )
cver=$( echo $version | sed 's/[^0-9]*//g' )
if [[ "$version" = "arm64" ]]
then
	echo "Checking if there is any update..."
	sudo service idena_$username stop
	cd /home/$username/idena-go
	wget -r -N -c -np -nd https://github.com/ltraveler/idena-go-arm64/raw/main/idena-go
	chmod +x idena-go
	sudo service idena_$username start
	echo -e "${LRED}IDENA NODE HAS BEEN SUCCESSFULLY UPDATED${NC}"
fi
if [[ "$lver" > "$cver" ]]
then
echo "New version is available"
sudo service idena_$username stop
wget https://github.com/idena-network/idena-go/releases/download/v$latver/idena-node-linux-$latver
chmod +x idena-node-linux-$latver
chown $username:$username idena-node-linux-$latver
mv idena-node-linux-$latver /home/$username/idena-go/idena-node
sudo service idena_$username start
echo $latver > /home/$username/idena-go/version
echo -e "${LRED}IDENA NODE HAS BEEN SUCCESSFULLY UPDATED${NC}"
fi
