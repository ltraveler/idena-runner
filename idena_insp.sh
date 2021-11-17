#!/bin/bash
latver=$( curl -s https://api.github.com/repos/idena-network/idena-go/releases/latest | grep -Po '"tag_name":.*?[^\\]",' | sed 's/"tag_name": "v//g' |  sed 's/",//g' ) 
username="$(whoami)"
version=$( cat /home/$username/idena-go/version )
echo $latver
echo $username
echo $version
lver=$( echo $latver | sed 's/[^0-9]*//g' )
cver=$( echo $version | sed 's/[^0-9]*//g' )
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
echo "New version has been succefully  installed"
fi
