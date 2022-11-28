# Changelog

## 0.4.3 (Nov 28, 2022)

### Bug Fixes

- SSH port detection fix

## 0.4.2 (Nov 27, 2022)

### Bug Fixes

- **ARM64**: update script won't start upgrading process in case if `idena-go` binary has the same size as the local one

## 0.4.1 (Nov 26, 2022)

### Changes

- Now Idena Runner compatible with `ARM64` servers like `Raspberry Pi`, `Ampere A1 Compute` and so on.<br><b>ATTENTION:</b> <ins><i>If you have a mobile device you have to use</i></ins> <b>[IDENA ARMer script](https://github.com/ltraveler/idena-armer)</b>.


## 0.3.7 (July 8, 2022)

### Bug Fixes

- Wrong call to Idena node upgrade script

## 0.3.6 (June 28, 2022)

### Bug Fixes

- In the case of importing private and node keys manually, the import process kept the default generated files instead of writing new values

## 0.3.5 (Apr 07, 2022)

- The password will be set the same as username in case if there is an empty answer on the password prompt in interactive mode 

## 0.3.4 (Mar 31, 2022)

### Bug Fixes

- ufw rules management updates
- correction related to existed screen session precheck

## 0.3.3 (Mar 31, 2022)

### Bug Fixes

- `--username` long option didn't work properly

## 0.3.2 (Mar 31, 2022)

### Bug Fixes

- bug fix related to use --long-options and corresponding arguments

## 0.3.1 (Mar 30, 2022)

### Bug Fixes

- some critical bugs have been fixed.\
**Attention:** _**v0.3.0 must be upgraded to the latest one**_

## 0.3.0 (Mar 30, 2022)

### Changes

- command line flags model has been completely reorganized.\
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
`./idena_install.sh -u ratel -p ratel -s -v 'latest' -b '0.3' -f '1' -l '7200000000000' -r '9189' -i '41283' -k '6e17f7490f7922f3224d41769ce5ed2a01030de69d77163a291a77e8280aad3' -a '33e32cd86ecfb3179e50208428541a1e' -d '0 0 * * *'`

## 0.2.9 (Mar 24, 2022)

### Changes

- flags `-u` and `-p` have been added as possible arguments to run the script 

## 0.2.8 (Mar 17, 2022)

### Changes

- Some improvements in user experience model

## 0.2.7 (Mar 15, 2022)

### Changes

- Some color style changes for better user experience

### Bug Fixes

- Small bug fixes related to SSH deny permissions for re-created usernames

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
