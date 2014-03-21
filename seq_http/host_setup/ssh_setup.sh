#!/bin/sh

sed -ri 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config
sed -ri 's/#PermitRootLogin yes/PermitRootLogin yes/g' /etc/ssh/sshd_config
sed -ri 's/PubkeyAuthentication no/PubkeyAuthentication yes/g' /etc/ssh/sshd_config
sed -ri 's/RSAAuthentication no/RSAAuthentication yes/g' /etc/ssh/sshd_config
sed -ri 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
sed -ri 's/#AuthorizedKeysFile %h/.ssh/authorized_keys/AuthorizedKeysFile  %h/.ssh/authorized_keys/g' /etc/ssh/sshd_config
mkdir -p /var/run/sshd
chmod -rx /var/run/sshd
ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key
mkdir /root/.ssh/
