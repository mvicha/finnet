ansible_ssh_private_key_file: "{{var_ssh_key}}"

ansible_ssh_common_args: ' -o "StrictHostKeyChecking=no" -o "ProxyCommand ssh -vvvv -i {{var_ssh_key }} -o StrictHostKeyChecking=no -W %h:%p ubuntu@${proxy_dns_name}"'