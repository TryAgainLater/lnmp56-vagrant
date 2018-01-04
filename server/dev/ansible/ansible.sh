#!/usr/bin/env bash

if [ $(dpkg-query -W -f='${Status}' ansible 2>/dev/null | grep -c "ok installed") -eq 0 ];
then

  # Update Repositories
  sudo apt-get update

  # Determine Ubuntu Version
  . /etc/lsb-release

  # Decide on package to install for `add-apt-repository` command
  #
  # USE_COMMON=1 when using a distribution over 12.04
  # USE_COMMON=0 when using a distribution at 12.04 or older
  USE_COMMON=$(echo "$DISTRIB_RELEASE > 12.04" | bc)

  if [ "$USE_COMMON" -eq "1" ];
  then
      sudo apt-get install -y software-properties-common
  else
      sudo apt-get install -y python-software-properties
  fi

  # Add Ansible Repository & Install Ansible
  sudo add-apt-repository -y ppa:ansible/ansible
  sudo apt-get update
  sudo apt-get install -y ansible
fi

# Setup Ansible for Local Use and Run
cp /vagrant/server/dev/ansible/inventories/dev /etc/ansible/hosts -f
chmod 666 /etc/ansible/hosts
cat /vagrant/server/dev/ansible/files/authorized_keys >> /home/vagrant/.ssh/authorized_keys
sudo ansible-playbook /vagrant/server/dev/ansible/dev.yml -e hostname=$1 --connection=local
