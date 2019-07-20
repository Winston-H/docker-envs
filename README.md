[Install Docker](https://docs.docker.com/install/)
```SG:
#
# purge old docker installation
#
sudo apt-get remove docker docker-engine docker.io containerd runc

#
# install pre-requests
#
sudo apt-get update
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
    
#
# add docker apt key and repo
#
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo apt-get update

#
# install docker-ce
#
sudo apt-get install docker-ce docker-ce-cli containerd.io

# if there are version mismatch, use following commands to install specific version of docker-ce
apt-cache madison docker-ce
sudo apt-get install docker-ce=<VERSION_STRING> docker-ce-cli=<VERSION_STRING> containerd.io
```


[Install Docker Compose](https://docs.docker.com/compose/install/)
```SG：
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
```

[Install nvidia-docker](https://github.com/NVIDIA/nvidia-docker)
```SG: Ubuntu
# If you have nvidia-docker 1.0 installed: we need to remove it and all existing GPU containers
docker volume ls -q -f driver=nvidia-docker | xargs -r -I{} -n1 docker ps -q -a -f volume={} | xargs -r docker rm -f
sudo apt-get purge -y nvidia-docker

# Add the package repositories
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | \
  sudo apt-key add -
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
  sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update

# Install nvidia-docker2 and reload the Docker daemon configuration
sudo apt-get install -y nvidia-docker2
sudo pkill -SIGHUP dockerd

# Test nvidia-smi with the latest official CUDA image
docker run --runtime=nvidia --rm nvidia/cuda:9.0-base nvidia-smi
```
[nvidia-docker with docker-compose](https://github.com/eywalker/nvidia-docker-compose)

[nvidia-docker2 with docker-compose](https://github.com/eywalker/nvidia-docker-compose/issues/23)
```SG：
#
# https://github.com/nvidia/nvidia-container-runtime#daemon-configuration-file
#
$ vi /etc/docker/daemon.json
{
    "default-runtime": "nvidia",
    "runtimes": {
        "nvidia": {
            "path": "/usr/bin/nvidia-container-runtime",
            "runtimeArgs": [ ]
        }
    }
}
```
