## Idena Runner

Bash Script implementation of the Idena network node installation wizard.

## Running `idena_install.sh`

Please make sure that you have a pure Ubuntu 20.04 installation.
To install Idena node using this script, please folow these steps:
* `git clone https://github.com/ltraveler/idena-runner.git` clone the repository
* `cd idena-runner`
* `chmod +x idena_install.sh` to make the script executable
* `./idena_install.sh` to run the script

### What the script is doing?

1. Checking if the idena.service exists;
2. Creating new user and password to run the Idena node daemon;
3. Upgrading Ubuntu packages and installing all requiered dependecies;
4. Downloading idena-go network node based on the version that user have entered. If the input is empty the script is downloading the latest one. The version history is available [here](https://github.com/idena-network/idena-go/releases);
5. Installing Idena-go and running it based on the config.json file from the repository;
6. Changing API and Private keys of the node to the custom ones if the user wants so;
7. Creating Idena Daemon and running it;
8. Installing and running firewall based on SSH and IPFS port numbers.

### About Idena Daemon?
The script is creating a service daemon called idena. Which starts on the boot.
#### You can use these command to control it:
* `service idena status`- to check the status 
* `service idena restart` - to restart the service
* `service idena stop` - to stop the service
* `service idena start` - to start the service

### Idena Donations

* `0xf041640788910fc89a211cd5bcbf518f4f14d831` - **All donations are welcomed and appreciated**;

### Other information
* If you are looking for a stable shared node service, please contact me on **Telegram**  `@ltrvlr`

### Contact information
* **Email** `ltraveler@protonmail.com`
* **Telegram** `@ltrvlr`

For more detailed information about **idena-go** client please check the official [idena-go](https://github.com/idena-network/idena-go) github repository.
