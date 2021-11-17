<h1 align="center">
  <img src="https://github.com/ltraveler/ltraveler/raw/main/images/idena-runner-logo.png" width="224px"/><br/>
  Idena RUNNER Script
</h1>
<p align="center"><b>Bash Script implementation</b> of the <b>Idena network node</b> installation wizard. <br> Install multiple instances of the <b>Idena-Go</b> in a simple and user-friendly way.</p>

<p align="center"><a href="https://github.com/ltraveler/idena-runner/releases/latest" target="_blank"><img src="https://img.shields.io/badge/version-v0.2.0-blue?style=for-the-badge&logo=none" alt="idena runner latest version" /></a>&nbsp;<a href="https://wiki.ubuntu.com/FocalFossa/ReleaseNotes" target="_blank"><img src="https://img.shields.io/badge/Ubuntu-20.04(LTS)+-00ADD8?style=for-the-badge&logo=none" alt="Ubuntu minimum version" /></a>&nbsp;<a href="https://github.com/ltraveler/idena-runner/blob/main/CHANGELOG.md" target="_blank"><img src="https://img.shields.io/badge/Build-Stable-success?style=for-the-badge&logo=none" alt="idena-go latest release" /></a>&nbsp;<a href="https://www.gnu.org/licenses/quick-guide-gplv3.html" target="_blank"><img src="https://img.shields.io/badge/license-GPL3.0-red?style=for-the-badge&logo=none" alt="license" /></a></p>

## 🚀&nbsp; Running `idena_install.sh` (requires root privileges)

Please make sure that you have a pure Ubuntu 20.04 installation.
To install Idena node using this script, please folow these steps:
* `git clone https://github.com/ltraveler/idena-runner.git` clone the repository
* `cd idena-runner`
* `chmod +x idena_install.sh` to make the script executable
* `./idena_install.sh` to run the script

## ✅&nbsp; Features

* Multiple Idena instances installation: 1 user - 1 instance
* Import the existing private/node keys during the installation process
* Automatic updates crontask that can be schedulled during the installation process
* Uncomplicated Firewall (UFW) configuration and automatic port rules updates during the idena-node instance installaltion 

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

##  ⚙️&nbsp;  About Idena Daemon
The script is creating a service daemon called idena. Which starts on the boot.
#### You can use these commands to control it:
* `service idena_$username status`- to check the status 
* `service idena_$username restart` - to restart the service
* `service idena_$username stop` - to stop the service
* `service idena_$username start` - to start the service

*where $username is required instance username

## 🗑️&nbsp; idena-runner instance update process (requires root privileges)

Run new version of the script and put the same username that you have used to install the instance that you are trying to update.
That will overwrite all required files.
***Be careful:*** **All files indide idena-go folder will be destroyed**.

## 🗑️&nbsp; Idena-go instance uninstallation process (requires root privileges)

1. `service idena_username stop` _stopping idena user instance_;
2. `pkill -u username` _killing all processes related to the user_;
3. `deluser --remove-home username` _removing related to idena-go instance user and all his files and folders_;
4. `rm /etc/cron.d/idena_update_username` _removing cron idena-go update related task_;
5. `rm /etc/systemd/system/idena_username.service` _removing idena daemon service related to the instance that we are uninstalling_;
6. `systemctl daemon-reload` and `systemctl reset-failed` _updating systemctl changes that we have made in the previous step_;
7. `ufw delete allow ipfs_port_number` you have to change ipfs_port_number to the ipfs port that you have used to install the idena-go instance. By default it is `40405`.

### 🤝&nbsp; Idena Donations

* `0xf041640788910fc89a211cd5bcbf518f4f14d831` - **All donations are welcomed and appreciated**;

### ℹ️&nbsp; Other information
* If you are looking for a stable shared node service, please contact me on **Telegram**  `@ltrvlr`

### 🗣️&nbsp; Contact information
* **Email** `ltraveler@protonmail.com`
* **Telegram** `@ltrvlr`

For more detailed information about **idena-go** client please check the official [idena-go](https://github.com/idena-network/idena-go) github repository.
