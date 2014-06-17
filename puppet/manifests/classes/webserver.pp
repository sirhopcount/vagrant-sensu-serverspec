# Class webserver
#
# This class handles the installation and configuration of a webserver
#
# Author
#   Adrian van Dongen sirhopcount@goodfellasonline.nl
#
# Version
#   0.1   Initial release
#
# Parameters:
#   None
#
# Requires:
#   - apache
#   - mysql
#   - serverspec
#   - sensu
#
class webserver {

## Apache2

  # Install apache2
  include apache

  # Create vhost for website somesite.vagrant.local
  apache::vhost { 'somesite.vagrant.local':
    priority      => '10',
    vhost_name    => '10.0.2.15',
    port          => '80',
    docroot       => '/var/www/somesite',
    serveradmin   => 'webmaster@vagrant.local',
    serveraliases => ['otherurl.vagrant.local',],
  }

## Mysql

  # Install MySQL server
  class { 'mysql::server':
    root_password => 'secret',
  }

  # Enable PHP
  class { '::mysql::bindings':
    php_enable    => 1,
  }

  # Create Database
  mysql::db { 'somesite':
    user     => 'somesitedba',
    password => 'secret',
    host     => 'localhost',
    grant    => ['all'],
  }

## Serverspec

  # Install serverspec
  class {'serverspec':}

  # Enable spec tests
  serverspec::spec {'base_spec.rb':}
  serverspec::spec {'apache2_spec.rb':}
  serverspec::spec {'somesite.vagrant.local_spec.rb':}

## Sensu

  # Install and configure sensu
  class { 'sensu':
    rabbitmq_password => 'secret',
    rabbitmq_port     => '5672',
    rabbitmq_host     => '192.168.50.4',
    client_name       => $fqdn,
    client_address    => '192.168.50.5',
  }

## Checks

  # Check: execute rspec tests every 30 seconds
  sensu::check {'rspec_testing':
    command  => '/etc/sensu/plugins/rspec_testing.rb',
    handlers => 'default',
    interval => '30',
    require  => File['rspec_testing.rb'],
  }

## Files and directories

  # Script: wrapper for serverspec
  file {'rspec_testing.rb':
    ensure => file,
    path   => '/etc/sensu/plugins/rspec_testing.rb',
    owner  => 'sensu',
    group  => 'sensu',
    mode   => '0555',
    source => 'puppet:///files/rspec_testing.rb'
  }

}
