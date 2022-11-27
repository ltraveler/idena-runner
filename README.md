<h1 align="center">
  <img alt="IDENA Runner Bash Script - fast idena-go network node deployment with possibility of multiple instances installation: 1 user - 1 idena-go node instance" src="https://github.com/ltraveler/ltraveler/raw/main/images/idena-runner-logo.png" width="224px"/><br/>
  Idena RUNNER Script
</h1>
<p align="center"><b>Bash Script implementation</b> of the <b>Idena network node</b> installation wizard. <br> Install multiple instances of the <b>Idena-Go</b> in a simple and user-friendly way.</p>

<p align="center"><a href="https://github.com/ltraveler/idena-runner/releases/latest" target="_blank"><img src="https://img.shields.io/github/v/release/ltraveler/idena-runner?style=for-the-badge&logo=none" alt="idena runner latest version" /></a>&nbsp;<a href="https://wiki.ubuntu.com/FocalFossa/ReleaseNotes" target="_blank"><img src="https://img.shields.io/badge/Ubuntu-20.04(LTS)+-00ADD8?style=for-the-badge&logo=none" alt="Ubuntu minimum version" /></a>&nbsp;<a href="https://github.com/ltraveler/idena-runner/blob/main/CHANGELOG.md" target="_blank"><img src="https://img.shields.io/badge/Build-Stable-success?style=for-the-badge&logo=none" alt="idena-go latest release" /></a>&nbsp;<a href="https://www.gnu.org/licenses/quick-guide-gplv3.html" target="_blank"><img src="https://img.shields.io/badge/license-GPL3.0-red?style=for-the-badge&logo=none" alt="license" /></a>&nbsp;<a href="https://github.com/ltraveler/idena-runner/blob/main/README.ru-RU.md" target="_blank"><img src="https://img.shields.io/badge/readme-РУССКИЙ-orange?style=for-the-badge&logo=none" alt="Скрипт Idena Runner" /></a></p>

## 🚀&nbsp; Running `idena_install.sh` (requires root privileges)

Please make sure that you have a pure Ubuntu 20.04 installation.
To install Idena node using this script, please folow these steps:
* `apt-get install -y git` installing git package
* `git clone https://github.com/ltraveler/idena-runner.git` clone the repository
* `cd idena-runner`
* `chmod +x idena_install.sh` to make the script executable
* `./idena_install.sh` to run the script

## ✅&nbsp; Features

* Multiple Idena instances installation: 1 user - 1 instance
* Import the existing private/node keys during the installation process
* Automatic updates crontask that can be schedulled during the installation process
* Uncomplicated Firewall (UFW) configuration and automatic port rules updates during the idena-node instance installaltion
* Possibility to install idena-go as a shared node with default recommended values

## 🙋&nbsp; What the script is doing?

1. Checking if the idena.service exists;
2. Creating new user and password to run the Idena node daemon;
3. Upgrading Ubuntu packages and installing all requiered dependecies;
4. Downloading idena-go network node based on the version that user have entered. If the input is empty the script is downloading the latest one. The version history is available [here](https://github.com/idena-network/idena-go/releases);
5. The script using pre-defined `config.json` file which can be changed during the installation process;
6. Installing Idena-go and running it based on the config.json file from the repository;
7. Changing API and Private keys of the node to the custom ones if the user wants so;
8. Creating cron job to check for idena-go updates ones once a day. You can specify the frequency during the installation process;
9. Creating Idena Daemon and running it;
10. Installing and running firewall based on SSH and IPFS port numbers.

### 🏛️&nbsp;  In case if you are installing a shared node:
1. The script will add `--profile=shared` to the service file;
2. You can set the most important args: `BlockPinThreshold`, `FlipPinThreshold`, `AllFlipsLoadingTime`
   - **Default values:** 
     - `BlockPinThreshold` = `0.3`
     - `FlipPinThreshold` = `1`
     - `AllFlipsLoadingTime` = `7200000000000`

##  ⚙️&nbsp;  About Idena Daemon
The script is creating a service daemon called idena. Which starts on the boot.
#### You can use these commands to control it:
* `service idena_$username status`- to check the status 
* `service idena_$username restart` - to restart the service
* `service idena_$username stop` - to stop the service
* `service idena_$username start` - to start the service

*where $username is required instance username

##  💻&nbsp;  Command Line Flags and Arguments
Since version _0.3.0_ the script could be run in silence mode (aka **push installation**).
All or part of the answers could be sent via flags and relevant arguments in the command line.
**flags:**\
            `-u` or `--username` - _username_\
            `-p` or `--password` - _password_ in case of using `-u` without `-p` the password would be the same as username\
            `-s` or `--shared` - _shared node installation_\
            `-v` or `--version` - _idena-go node client version_ or _latest_ to download the latest one\
            `-b` or `--blockpinthreshold` - _Block Pin Threshold_ if not set but `-f` and/or `-l` have been applied, the script will use the default recommended value [`0.3`]\
            `-f` or `--flippinthreshold` - _Flip Pin Threshold_ if not set but `-b` and/or `-l` have been applied, the script will use the default recommended value [`1`]\
            `-l` or `--allflipsloadingtime` - _All Flips Loading Time_ if not set but `-b` and/or `-f` have been applied, the script will use the default recommended value [`7200000000000`]\
            `-r` or `--rpcport` - _RPC Port_ aka _HTTP Port_\
            `-i` or `--ipfsport` - _IPFS Port_\
            `-k` or `--privatekey` - _IDENA Private Key_ aka _nodekey_\
            `-a` or `--apikey` - _IDENA Node API Key_\
            `-d` or `--updatefreq` - _Update frequency in CRON expression format_

**Apart from `-s` or `--shared` the rest of the flags need an argument inside '' (_apostrophe_)**

_**For example:**_\
`./idena_install.sh -u 'ratel' -p 'ratel' -s -v 'latest' -b '0.3' -f '1' -l '7200000000000' -r '9189' -i '41283' -k '6e17f7490f7922f3224d41769ce5ed2a01030de69d77163a291a77e8280aad3' -a '33e32cd86ecfb3179e50208428541a1e' -d '0 0 * * *'`

## ✔️&nbsp; Idena-runner instance update process (requires root privileges)

1. Backup the private key (`/home/idena_instance_username/idena-go/datadir/keystore/nodekey`)
2. Backup the node api.key (`/home/idena_instance_username/idena-go/datadir/api.key`)
3. Run the latest version of the idena-runner script and put the same username that you have used to install the instance that you are trying to update.
That will overwrite all required files.
***Attention:*** **all files inside the idena-go folder will be permanently deleted**.
4. `service idena_$username stop` - to stop the updated instance.
5. Restore your private and API keys from the backup that you have made on the 1st step.
6. `service idena_$username start` - to start the updated instance.

## 🗑️&nbsp; Idena-go instance uninstallation process (requires root privileges)

1. `service idena_username stop` _stopping idena user instance_;
2. `pkill -u username` _killing all processes related to the user_;
3. `deluser --remove-home username` _removing related to idena-go instance user and all his files and folders_;
4. `rm /etc/cron.d/idena_update_username` _removing cron idena-go update related task_;
5. `rm /etc/systemd/system/idena_username.service` _removing idena daemon service related to the instance that we are uninstalling_;
6. `systemctl disable idena_username` _disabling idena daemon service related to the instance that we are uninstalling_
7. `systemctl daemon-reload` and `systemctl reset-failed` _updating systemctl changes that we have made in the previous step_;
8. `ufw show added | grep "IDENA Instance for user $username" | awk '{ gsub("ufw","ufw delete",$0); system($0)}'` do not forget to replace `$username` to the real name of deleted user;
9. `sudo visudo` you have to find and delete the line related to the deleted user at the end of the file;
10. `nano /etc/ssh/sshd_config` - you have to delete username from _DenyUsers_ group;
11. `sudo sshd -t` - to be sure that your latest changes of _sshd_config_ file is correct;
12. `sudo service sshd restart` - to restart _sshd daemon_.

### 🤝&nbsp; Idena Donations

* `0xf041640788910fc89a211cd5bcbf518f4f14d831` - **All donations are welcomed and appreciated**;

### ℹ️&nbsp; Other information
* If you are looking for a stable shared node service, please contact me on **Telegram**  `@ltrvlr`

### 🗣️&nbsp; Contact information
* **Email** `ltraveler@protonmail.com`
* **Telegram** `@ltrvlr`

For more detailed information about **idena-go** client please check the official [idena-go](https://github.com/idena-network/idena-go) github repository.
