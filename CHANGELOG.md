# Changelog

## 0.2.6 (Mar 06, 2022)

### Changes

- Some changes in user-interactive dialog to make it more user-friendly
- Possibility to set all default values in `config.json` in case of the shared node installation

## 0.2.5 (Feb 09, 2022)

### Changes

- During the shared node installation wizard user can modify some important args: `BlockPinThreshold`, `FlipPinThreshold`, `AllFlipsLoadingTime`
- Now the script is overwriting `config.json` file to the default one to prevent possible conflicts in case of multiple installations

### Bug Fixes

- In case of using the same cloned folder for multiple instances installation arg `--profile=shared` was recorded multiple times: as many as quantity of successful installations

## 0.2.4 (Jan 28, 2022)

### Changes

- optional key `--profile=shared` has been added to the Idena service daemon 

## 0.2.3 (Jan 25, 2022)

### Security improvement

- SSH connection restrictions for all idena-go instances users. Users that has been added to run Idena instance are restricted to establish SSH connection.

## 0.2.2 (Dec 21, 2021)

### Bug Fixes

- root as a username fool-tolerance has been added.

## 0.2.1 (Nov 16, 2021)

### Bug Fixes

- ill-conditioned comparison related to the version number. Right now, the scheduled node instance update script working in the proper way.

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
