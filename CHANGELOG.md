# Changelog

## 0.2.0 (Nov 05, 2021)

### Bug Fixes

- The script is always checking that the ports from config.json are not used by another idena-go instance. If the port has been already used the script is asking to change the port number to another one.

## 0.1.9 (Nov 01, 2021)

### Bug Fixes

- Some important bug fixes about duplicate records that could appear in case of reinstalling idena node with the same username

## 0.1.8 (Oct 22, 2021)

### Changes

- The GitHub idenachain.db repository has been set as the primary one. If it is not available there are two more mirrors

## 0.1.7 (Oct 18, 2021)

### Changes

- In case if the primary source of Idena blockchain bootstrap is not available the script will try to download it from the mirrors 

## 0.1.6 (Oct 18, 2021)

### Bug Fixes

- cron job to check for the node updates has to be run with root privileges

## 0.1.5 (Oct 17, 2021)

### Changes

- Multiple idena node instances installation
- Default `config.json`

### Bug Fixes

- remove idena node instance ports from ufw in case if we are removing the service
- small bug fixes

## 0.1.4 (Oct 9, 2021)

### Changes

- Default configuration file `config.json` can be changed during the installation process
- User can customize frequency when the script will check idena-go updates in cron schedule expressions format

### Bug Fixes

- Small bug fixes

## 0.1.3 (Oct 8, 2021)

### Changes

- Auto update function has been added

### Bug Fixes

- Some small bug fixes

## 0.1.2 (Oct 5, 2021)

### Changes

- When the version number in the input dialog of the script is empty the script will get the latest one (special thks to @katant)
- Script uses the local copy of configuration files (`config.json` and `idena.service`)  

## 0.1.1 (Oct 3, 2021)

### Bug Fixes

- idena.service creation

## 0.1.0 (Oct 3, 2021)

### Changes

- First released version
