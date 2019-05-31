# Setting up LEMP
Scripts for developing on the cloud or VM

## Setting up on a VM
Note: Tested on Ubuntu 18.04+

First, download or clone "lemp_setup.sh" file into Linux system.

Make lemp_setup.sh executable first:
```
chmod u+x lemp_setup.sh
```

Run
```
./lemp_setup.sh
```

## Setting up on Docker
Note: Tested on Ubuntu 18.04, Mac, and Windows

To run container from build (don't forget to change your host folder)

```
docker run -it -dP -v <local machine's folder>:/var/www/html --name lempserver -d linuxconfig/lemp
```

For example (Windows):
```
docker run -it -dP -v C:\Users\Collin\Documents\_docker_containers\lempserver:/var/www/html --name lempserver -d linuxconfig/lemp
```

For example (Mac):
```
docker run -it -dP -v /Users/admin/Documents/lempserver:/var/www/html --name lempserver -d linuxconfig/lemp
```
