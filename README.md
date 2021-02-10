# NHOS Local Log Server

## Instructions 

How to get the script running on NHOS:

1. Save the `server.sh` script on `/mnt/nhos/scripts.sh/` directory. Check how in official NHOS documentation [here](https://github.com/nicehash/NHOS/blob/master/nhos_boot_scripts.md).
2. Put the `index.html` on `/mnt/nhos/` root directory.
3. Access to your IP using port :8080 from your browser using local NHOS IP address Ex. 192.168.0.X:8080

## Features

- Actions menu: Reboot, Update Logs Now and Setup refresh rate in seconds.
- Logs view: shows tail òutput from temps, miner and nhos logs `tail /var/log/nhos/nhm/miners/*.log /var/log/nhos/*.log`

![image](https://user-images.githubusercontent.com/3067335/107544596-647c4980-6b98-11eb-87f1-49c21a35c829.png)

For more information about NHOS check: https://static.nicehash.com/marketing%2Fnhos-guide-en.pdf

# Roadmap

- Add full local monitoring using mioners APIs :rocket:
- Add nice CSS stylesheets :sparkles:
- Keep it simple in the process :100:

Happy Mining Monitoring! :heart:

## Donate

Feel free to donate a few satoshis to my Lightning Network wallet here :smile:

![image](https://user-images.githubusercontent.com/30659361/107547556-94791c00-6b9b-11eb-9e3d-b0ffc15828aa.png)

```
lnbc1pszg966pp5wj57dmypdzg625dn802wsh0z9x5zz3x5hp0lfww3a396yxzycjdsdqu2askcmr9wssx7e3q2dshgmmndp5scqzpgxqyz5vqsp50epnrke86vmxs6p8hwr779nwc0tv4ranar3t5wj03cr839w2q04q9qy9qsq76fehdkp3s8jgj5gzgyx5fxkvwjz82zpgy3trympmtk7ua8fy8f5x0pkuc23z6vz9qgyt0r07s7kfl58zjrqalklsy6p607yjh7hcngp5t3sja
```
