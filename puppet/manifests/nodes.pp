# Node: mon01.vagrant.local
node 'mon01.vagrant.local' {

## Base

  # Include classes
  class {'base': }

  # Install ruby-json (dependency of sensu-puppet)
  package { 'ruby-json':
    ensure => present,
  }

## Role

  class {'confmon': }

}

node 'web01.vagrant.local' {

## Base

  # Include classes
  class {'base': }

  # Install ruby-json (dependency of sensu-puppet)
  package { 'ruby-json':
    ensure => present,
  }

## Role

  class {'webserver': }

}

# If a node does not match then include the base class
node 'default' {

  class {'base': }

}
