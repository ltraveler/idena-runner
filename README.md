<h1 align="center">
  <img src="https://github.com/ltraveler/ltraveler/raw/main/images/idena-runner-logo.png" width="224px"/><br/>
  Idena RUNNER Script
</h1>
<p align="center"><b>Bash Script implementation</b> of the <b>Idena network node</b> installation wizard. <br> Install multiple instances of the <b>Idena-Go</b> in a simple and user-friendly way.</p>

<p align="center"><a href="https://github.com/ltraveler/idena-runner/releases/latest" target="_blank"><img src="https://img.shields.io/badge/version-v0.2.0-blue?style=for-the-badge&logo=none" alt="idena runner latest version" /></a>&nbsp;<a href="https://wiki.ubuntu.com/FocalFossa/ReleaseNotes" target="_blank"><img src="https://img.shields.io/badge/Ubuntu-20.04(LTS)+-00ADD8?style=for-the-badge&logo=none" alt="Ubuntu minimum version" /></a>&nbsp;<a href="https://github.com/ltraveler/idena-runner/blob/main/CHANGELOG.md" target="_blank"><img src="https://img.shields.io/badge/Build-Stable-success?style=for-the-badge&logo=none" alt="idena-go latest release" /></a>&nbsp;<a href="https://www.gnu.org/licenses/quick-guide-gplv3.html" target="_blank"><img src="https://img.shields.io/badge/license-GPL3.0-red?style=for-the-badge&logo=none" alt="license" /></a></p>

## Running `idena_install.sh`

Please make sure that you have a pure Ubuntu 18.04 installation.
To install Idena node using this script, please folow these steps:
* `git clone https://github.com/ltraveler/idena-runner.git` clone the repository
* `cd idena-runner`
* `chmod +x idena_install.sh` to make the script executable
* `./idena_install.sh` to run the script

### Features

* Multiple Idena instances installation: 1 user - 1 instance
* Import the existing private/node keys during the installation process
* Automatic updates crontask that can be schedulled during the installation process
* Uncomplicated Firewall (UFW) configuration and automatic port rules updates during the idena-node instance installaltion 

### What the script is doing?

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

### About Idena Daemon
The script is creating a service daemon called idena. Which starts on the boot.
#### You can use these commands to control it:
* `service idena_$username status`- to check the status 
* `service idena_$username restart` - to restart the service
* `service idena_$username stop` - to stop the service
* `service idena_$username start` - to start the service

*where $username is required instance username


### Idena Donations

* `0xf041640788910fc89a211cd5bcbf518f4f14d831` - **All donations are welcomed and appreciated**;

### Other information
* If you are looking for a stable shared node service, please contact me on **Telegram**  `@ltrvlr`

### Contact information
* **Email** `ltraveler@protonmail.com`
* **Telegram** `@ltrvlr`

For more detailed information about **idena-go** client please check the official [idena-go](https://github.com/idena-network/idena-go) github repository.
