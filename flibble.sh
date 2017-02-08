#!/bin/bash

yum update -y 
yum install epel-release -y 
yum install ansible git -y
ansible-pull flibble.yaml -U https://github.com/mrcrilly/MrFlibble.git -f --clean --accept-host-key -i localhost,
