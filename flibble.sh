#!/bin/bash

yum update -y 
yum install epel-release -y 
yum install ansible git -y
ansible-pull flibble.yaml -U https://github.com/mrcrilly/MrFlibble.git -f --clean --accept-host-key -i localhost, -e mrflibble_letsencrypt_email="${mrflibble_letsencrypt_email}" -e mrflibble_domain_name="${mrflibble_domain_name}"
