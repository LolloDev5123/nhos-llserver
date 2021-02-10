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

# Roadmap

- Add full local monitoring using mioners APIs :rocket:
- Add nice CSS stylesheets :sparkles:
- Keep it simple in the process :100:

Happy Mining Monitoring! :heart:

## Donate

Feel free to donate a few satoshis to my BTC wallet here (Lightning wallet blew up, no more inbound capacity, contact me if you want to support/donate using lightning network) :smile:

![image](https://user-images.githubusercontent.com/30659361/107554113-7dd6c300-6ba3-11eb-88f7-13938432dc41.png)

```
bitcoin:bc1qwrvlj3q5zkvu9qeuy0utzgau4sa6sey5nn3nc4
```
