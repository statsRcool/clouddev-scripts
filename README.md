# Cloud Dev Scripts
Scripts for developing on the cloud or VM

## Setting up on a VM
Note: Tested on Ubuntu 18.04+

First, download or clone "dev_setup.sh" file into Linux system.

Make dev_setup executable first:
```
chmod u+x dev_setup.sh
```

Run
```
./dev_setup.sh
```

For the first time select "1) setup_codeserver" from the menu, this will setup and run code-server on port 8080. 

Visit port 8080 to start programming.

### Setting up a systemd service

Run
```
./dev_setup.sh
```

Select "4) setup_codeserver_service" and follow the prompt

## Setting up on Docker
Note: Tested on Ubuntu 18.04, Mac, and Windows

First, download or clone "dev_setup.Dockerfile" into host system.

```
docker build -t code_server:latest -f dev_setup .
```

To run container from build (don't forget to change your host folder)

```
docker run -it -p 8080:8080 -v <local machine's folder>:/root -e PASSWORD='YourP@ssw0rd' --name <name of container> -d code_server:latest --allow-http -p 8080
```

For example (Mac):
```
docker run -it -p 8080:8080 -v /Users/admin/Documents/codeserver:/root -e PASSWORD='YourP@ssw0rd' --name devserver -d code_server:latest --allow-http -p 8080
```

