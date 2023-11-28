#! /bin/bash

%{ if instance_name == "bastion" }
sudo apt-get update
sudo apt-get install -y python3 ansible git
%{ endif }
