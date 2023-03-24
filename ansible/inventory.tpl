[controllers]
%{ for index, ip in controller_public_ips ~}
controllers_${index} ansible_host=${ip} ansible_user=kube
%{ endfor ~}


[workers]
%{ for index, ip in worker_public_ips ~}
workers_${index} ansible_host=${ip} ansible_user=kube
%{ endfor ~}
