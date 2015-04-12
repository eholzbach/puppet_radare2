#!/bin/sh

wget https://apt.puppetlabs.com/puppetlabs-release-wheezy.deb
dpkg -i puppetlabs-release-wheezy.deb
apt-get update
apt-get install -y puppet git
mkdir -p /opt/puppet/modules
git clone https://github.com/eholzbach/puppet_radare2.git /opt/puppet/modules/puppet_radare2
puppet apply --modulepath=/opt/puppet/modules /opt/puppet/modules/puppet_radare2/manifests/bootstrap.pp
