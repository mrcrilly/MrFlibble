#!/bin/bash

yum update -y 
yum install epel-release -y 
yum install ansible git -y
ansible-pull flibble.yaml -U ${mrflibble_git_repository} -f --clean --accept-host-key -i localhost, -e mrflibble_letsencrypt_email="${mrflibble_letsencrypt_email}" -e mrflibble_domain_name="${mrflibble_subdomain_name}.${mrflibble_domain_name}"
