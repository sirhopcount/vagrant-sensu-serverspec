# Class confmon
#
# This class handles the installation and configuration of a configuration monitor
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
#   - rabbitmq
#   - redis
#   - sensu
#
class confmon {

## RabbitMQ

  # Install rabbitmq
  class { '::rabbitmq':
        delete_guest_user => true,
  }

  # Create rabbitmq vhost for /sensu
  rabbitmq_vhost { '/sensu':
    ensure  => present,
    require => Class['::rabbitmq'],
  }

  # Create rabbitmq user named sensu
  rabbitmq_user { 'sensu':
    password => 'secret',
    require  => Class['::rabbitmq'],
  }

  # Set permissions for user sensu on vhost sensu
  rabbitmq_user_permissions { 'sensu@/sensu':
    configure_permission => '.*',
    read_permission      => '.*',
    write_permission     => '.*',
    require              => Class['::rabbitmq'],
  }

## Redis

  # Install redis
  class { 'redis': }

## Sensu

  # Install and configure redis
  class {'sensu':
    server            => true,
    api               => true,
    rabbitmq_user     => 'sensu',
    rabbitmq_password => 'secret',
    client_name       => $fqdn,
    client_address    => '192.168.50.4',
  }

  class { 'uchiwa':
    require => Class['sensu'],
  }

  uchiwa::api { 'Main Server':
    host    => '192.168.50.4',
    ssl     => false,
    port    => 4567,
    user    => 'sensu',
    pass    => 'secret',
    path    => '',
    timeout => 5000
  }

}
