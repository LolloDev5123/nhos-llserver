# NHOS Local Log Server

## Instructions 

How to get the script running on NHOS:

1. Save the `server.sh` script on `/mnt/nhos/scripts.sh/` directory. Check how in official NHOS documentation [here](https://github.com/nicehash/NHOS/blob/master/nhos_boot_scripts.md).
2. Put the `index.html` on `/mnt/nhos/` root directory.
3. Access to your IP using port :8080 from your browser using local NHOS IP address Ex. 192.168.0.X:8080

## Features

- Actions menu: Reboot, Update Logs Now and Setup refresh rate in seconds.
- Logs view: shows tail òutput from temps, miner and nhos logs `tail /var/log/nhos/nhm/miners/*.log /var/log/nhos/*.log`

![image](https://user-images.githubusercontent.com/30659361/107549678-1ff3ac80-6b9e-11eb-85d3-3369c9888c4d.png)

For more information about NHOS check: https://static.nicehash.com/marketing%2Fnhos-guide-en.pdf

## Roadmap

- Add full local monitoring using miners APIs :rocket:
- Add nice CSS stylesheets :sparkles:
- Keep it simple in the process :100:

## Donate

Feel free to donate a few Satoshi using your Lighning Wallet ⚡ :smile:

[![sathoshis](https://img.shields.io/badge/Donate-Satoshi%20%E2%9A%A1-blueviolet)](https://totakaro.github.io/donate)

Happy Mining Monitoring! :heart:
