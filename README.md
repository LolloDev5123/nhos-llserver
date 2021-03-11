# NHOS Local Log Server

Simple server in one single file to manage your NHOS rig :rocket:

## Instructions 

How to get the script running on NHOS:

1. Open `server.sh` with a [compatible text editor](https://github.com/nicehash/NHOS/blob/master/nhos_configuration.md#what-you-will-need), and edit `ALLOW` variable Ex. `ALLOW="192.168.0.0/24"` to allow access only from IPs in your local network, check more here: https://nmap.org/ncat/guide/ncat-access.html
2. Save the `server.sh` script on `/mnt/nhos/scripts.sh/` directory. Check how in official NHOS documentation [here](https://github.com/nicehash/NHOS/blob/master/nhos_boot_scripts.md).
3. Access to your local NHOS rig IP using your browser Ex. http://192.168.0.42

## Features

### Go Top / Go Bottom

Buttons to navigate to the top and bottom of the logs

![image](https://user-images.githubusercontent.com/30659361/110710803-833c2300-81cc-11eb-8277-2861c29fa3b3.png)

### Reboot rig

Button to reboot your rig 

![image](https://user-images.githubusercontent.com/30659361/110710940-ac5cb380-81cc-11eb-9eb4-4f514613cc8e.png)

### AutoScroll?

Option to auto scroll the logs

![image](https://user-images.githubusercontent.com/30659361/110711167-12e1d180-81cd-11eb-88bc-93dc05aa9026.png)

### Color?

Option to show logs color (it uses 3rd party [AnsiUp.js](https://github.com/drudru/ansi_up) dependency)

![image](https://user-images.githubusercontent.com/30659361/110711352-6a803d00-81cd-11eb-8ad5-3c77dbb4a4a9.png)

![image](https://user-images.githubusercontent.com/30659361/110711381-77049580-81cd-11eb-90a0-ec93f25f23b5.png)

### OC Settings

Tool to setup your oc settings: TDP, CORE CLOCKS and MEMORY CLOCKS

![image](https://user-images.githubusercontent.com/30659361/110711499-aadfbb00-81cd-11eb-8621-1cad2a0a83dc.png)

![image](https://user-images.githubusercontent.com/30659361/110710375-bcc05e80-81cb-11eb-96ea-f63a106a4c04.png)

## Miners Logs

Shows miners logs in `/var/log/nhos/nhm/miners`

![image](https://user-images.githubusercontent.com/30659361/110711741-0e69e880-81ce-11eb-8b30-de1fda4b488c.png)

For more information about NHOS check official sources: https://static.nicehash.com/marketing%2Fnhos-guide-en.pdf and https://github.com/nicehash/NHOS

## Roadmap

- Add full local monitoring using miners APIs :rocket:
- Add more nice CSS stylesheets :sparkles:
- Keep it simple in the process :100:

## Donate

Feel free to collaborate with code or donate a few Satoshi using your Lighning Wallet ⚡ :smile:

[![sathoshis](https://img.shields.io/badge/Donate-Satoshi%20%E2%9A%A1-blueviolet)](https://totakaro.github.io/donate)

Happy Mining Monitoring! :heart:
