# Class: Base
#
# This class is does the "base" configuration of nodes.
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
#   None
#
# Sample Usage:
#
#   # Include base class
#   class {'base': }
#
class base {

  # Configure DNS settings
  class { 'resolv_conf':
    searchpath  => 'vagrant.local',
    nameservers => ['8.8.8.8'],
  }

  # Array of software packages that need to be installed
  $pkgs_allow = [
                    'sysstat',
                    'atop',
                    'curl',
                    'htop',
                    'multitail',
                    'ngrep',
                    'vim',
                    'swaks',
                    'tcpdump',
                ]

  # Install software packages
  package{ $pkgs_allow:
    ensure  => present,
  }

}
