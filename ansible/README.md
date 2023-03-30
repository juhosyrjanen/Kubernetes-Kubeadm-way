# Collection of Ansible roles 

Usage: 

```shell
ansible-playbook -i ansible/inventory.ini -u kube --private-key id_rsa ansible/main.yml
```

## Summary

The purpose of this Ansible collection is to prepare nodes and perform bootstrapping of a HA Kubernetes cluster. 
The collection assumes that nodes are running a recent version of Ubuntu or Debian Linux. 

`invetory.ini` is populated by Terraform and SSH keys stored in project root and referenced in the [Terraform code](https://github.com/juhosyrjanen/kube/blob/f0ad27f3b284cf6d39849da7951473d48ac752f7/tf/variables.tf#L1)
are injected to the nodes automatically. 

No further configuration is needed to use the module.

## Roles

### init_nodes

A basic roles that updates and installs Kubernetes components to the nodes directly from package repository.

### containerd

This role installs `containerd`, `runc` and needed CNI plugins directly from official binaries. It also creates a `containerd`
service. w

### k8s_control_plane

This role uses `kubeadm` to bootstrap Kubernetes control plane on the three controller nodes. It starts with the first
controller in the hosts list perfroming the following;

- `kubeadm init` - initialise the first controller in the control plane. 
- Fetches the `kubeconfig` to the local machine's Ansible directory
- Sets up a HAproxy healthcheck
- Prepares the `kubeadm join` command to be ran on the rest of the controllers