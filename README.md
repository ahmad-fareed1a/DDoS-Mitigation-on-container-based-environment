# Project Setup Guide (DDoS-Mitigation-on-container-based-environment)
This guide will walk you through the setup process for communicating with Docker containers within a virtual machine environment. Please follow the instructions carefully to ensure proper configuration.
## Virtual Machine Configuration
### VMware
Enable Bridge Mode:
    Navigate to VMware global settings: View > Virtual Network Editor.
    Change settings and add a bridge network.
    Apply the changes and click OK.
Virtual Machine Network Adapter Configuration:
    Open VMware Virtual Machine Settings.
    Select the network adapter and set it to Bridge mode.

### VirtualBox
Virtual Machine Network Configuration:
    Click on the virtual machine settings.
    Navigate to the network section.
    Set the adapter to Bridged Adapter.
    Set Promiscuous Mode to Allow All.
    Click OK to save the changes.

## Docker Network Setup
The Docker network is configured using 'macvlan'.

"sudo docker network create -d macvlan --subnet 10.41.0.0/16 --gateway 10.41.0.1 -o parent=eth0 mac-vlan"

Ensure to replace the IP addresses accordingly. To find the gateway, use the "ip r" command, and specify the appropriate parent network adapter.
For enabling promiscuous mode on VMware, use the following command:
"sudo ip link set eth0 promisc on"

## Container Setup
To build a container:
    Move all the files to a directory.
    Build the container using the following command:
    "sudo docker build -t web-container -f Dockerfile.web ."
    To run the container on the macvlan network:
    "sudo docker run --name web-container -it --network mac-vlan --ip 10.41.165.4 --name macweb –privileged web-container"
    Ensure to adjust the IP address and container name as needed.

## Verify Network Settings
Check the IPs of both the container and the virtual machine to ensure they are on the same network.

By following these steps, your environment should be properly configured for communicating with Docker containers within your virtual machine setup.

Useful commands for Docker:
To see the docker network: 
```sudo docker network inspect mac-vlan```

To see IP of a container: 

```sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' web-container ```
To see running containers / all containers:
```sudo doccker ps```
```sudo docker ps -a```
To remove, start, stop, and restart a container: 'use either container ID or name'
```sudo docker rm 90995300ab7e``` 
```sudo docker stop web-container``` 
```sudo docker start web-container```
```sudo docker restart web-container```
To get interactive shell of a container: 
```sudo docker exec -it web-container /bin/bash```
To restart a service inside a container 'based on ubuntu-image':
```service apache2 restart```
It will remove the interactive shell access, after that restart the container using below command:
```sudo docker restart web-container```
