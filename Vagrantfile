# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Set box
  config.vm.box = "ubuntu-12.04.4-64bit-vbox-4.3.10-puppet-2.7.25"
  config.vm.box_url = "http://vagrant.goodfellasonline.nl/ubuntu-12.04.4-64bit-vbox-4.3.10-puppet-2.7.25.box"

  # Set box memory to 1024
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "1024"]
  end

  # Always run apt-get update
  config.vm.provision "shell", inline: "apt-get update"

  # Create an extra shared folder for the puppet files folder
  config.vm.synced_folder "puppet/files", "/etc/puppet/files"

  # Puppet provisioning
  config.vm.provision :puppet,
    :options => ["--fileserverconfig=/vagrant/fileserver.conf", "--verbose"] do |puppet|
    #:options => ["--verbose"] do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.module_path    = "puppet/modules"
    puppet.manifest_file  = "site.pp"
  end

  # Sensu server
  config.vm.define :server do |conf|
    conf.vm.hostname = 'mon01.vagrant.local'
    conf.vm.network :private_network, ip: "192.168.50.4"
    conf.vm.network :forwarded_port, guest: 8080, host: 8080
  end

  # Sensu client
  config.vm.define :client do |conf|
    conf.vm.hostname = 'web01.vagrant.local'
    conf.vm.network :private_network, ip: "192.168.50.5"
  end

end
