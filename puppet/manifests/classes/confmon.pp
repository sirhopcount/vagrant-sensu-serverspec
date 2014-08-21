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

class { 'rabbitmq':
  ssl               => false,
  delete_guest_user => true,
}
-> rabbitmq_vhost { 'sensu': }
-> rabbitmq_user  { 'sensu': password => 'secret' }
-> rabbitmq_user_permissions { 'sensu@sensu':
  configure_permission => '.*',
  read_permission      => '.*',
  write_permission     => '.*',
}

## Redis

  # Install and configure redis
  class { 'redis': }

## Sensu

  class { 'sensu':
    server                   => true,
    api                      => true,
    purge_config             => true,
    rabbitmq_password        => 'secret',
    rabbitmq_host            => 'localhost',
    rabbitmq_port            => 5672,
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
