#!/bin/bash
latver=$( curl -s https://api.github.com/repos/idena-network/idena-go/releases/latest | grep -Po '"tag_name":.*?[^\\]",' | sed 's/"tag_name": "v//g' |  sed 's/",//g' ) 
username=$( cat /etc/systemd/system/idena.service | grep 'User=' | sed 's/User\=//g' )
version=$( cat /home/$username/idena-go/version )
echo $latver
echo $username
echo $version
lver=$( echo $latver | sed 's/[^0-9]*//g' )
cver=$( echo $version | sed 's/[^0-9]*//g' )
if [ $lver -gt $cver ]
then
echo "New version is available"
service idena stop
wget https://github.com/idena-network/idena-go/releases/download/v$latver/idena-node-linux-$latver
chmod +x idena-node-linux-$latver  
mv idena-node-linux-$latver /home/$username/idena-go/idena-node
service idena start
echo $latver > /home/$username/idena-go/version
echo "New version has been succefully  installed"
fi
