# Kubernetes the Kubeadm way

> Hard way 2 hard 4 me

This project contains some automation to boot up Kubernetes cluster using Ansible and Vagrant VirtualBox provider. 

There's also Terraform to allow provisioning the infrastructure in Google Cloud, however still WIP.

## Requirements 

- VirtualBox
- Vagrant 
- Ansible
- Free local IP C-block
- (GCP) 

## Usage

Start virtual machines
```shell
cd vagrant
vagrant up
```

Bootstrap Kubernetes cluster
```shell
ansible-playbook -i ansible/inventory.ini  ansible/main.yml
```

## HAproxy

See health check status page http://192.168.56.120:9000/
