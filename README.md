# NHOS Local Log Server

Simple server in one single file to manage your NHOS rig :rocket:

![image](https://user-images.githubusercontent.com/30659361/111986242-affd0e00-8adb-11eb-975a-6c3cbe1397e0.png)

## Instructions 

How to get the script running on NHOS:

1. Open `server.sh` with a [compatible text editor](https://github.com/nicehash/NHOS/blob/master/nhos_configuration.md#what-you-will-need), and edit `ALLOW` variable Ex. `ALLOW="192.168.0.0/24"` to allow access only from IPs in your local network, check more here: https://nmap.org/ncat/guide/ncat-access.html
2. Save the `server.sh` script on `/mnt/nhos/scripts.sh/` directory. Check how in official NHOS documentation [here](https://github.com/nicehash/NHOS/blob/master/nhos_boot_scripts.md).
3. Access to your local NHOS rig IP using your browser Ex. http://192.168.0.42

## Features

## Toolbar

![image](https://user-images.githubusercontent.com/30659361/111987413-38c87980-8add-11eb-9a0d-2bf65316d05a.png)

## Multi rig local manager

![image](https://user-images.githubusercontent.com/30659361/111988914-1d5e6e00-8adf-11eb-9ff4-ffff995974ac.png)

## Edit your configuration.txt (fan setup)

![image](https://user-images.githubusercontent.com/30659361/111988023-f2bfe580-8add-11eb-8963-0d60be8dd5b4.png)

### OC Settings

Tool to setup your oc settings: TDP, CORE CLOCKS and MEMORY CLOCKS

![image](https://user-images.githubusercontent.com/30659361/111989646-0c622c80-8ae0-11eb-8f6c-5bfac1adced5.png)

## Miners Logs

Shows miners logs in `/var/log/nhos/nhm/miners`

![image](https://user-images.githubusercontent.com/30659361/111988739-dff9e080-8ade-11eb-891b-764788c99011.png)

For more information about NHOS check official sources: https://static.nicehash.com/marketing%2Fnhos-guide-en.pdf and https://github.com/nicehash/NHOS

## Roadmap

- Add full local monitoring using miners APIs :rocket:
- Add more nice CSS stylesheets :sparkles:
- Keep it simple in the process :100:

## Donate

Feel free to collaborate with code or donate a few Satoshi using your Lighning Wallet ⚡ :smile:

[![sathoshis](https://img.shields.io/badge/Donate-Satoshi%20%E2%9A%A1-blueviolet)](https://totakaro.github.io/donate)

Happy Mining Monitoring! :heart:
