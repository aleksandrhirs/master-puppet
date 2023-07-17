node default {
  include role::web_server

  firewalld_port { 'Open port 8888 in the public zone':
    ensure   => present,
    zone     => public,
    port     => 8888,
    protocol => 'tcp',
  }

  firewalld_service { 'Allow HTTP from the external zone':
      ensure  => 'present',
      service => 'http',
      zone    => 'public',
  }


  include wcg

}

node slave1.puppet {
  include role::dev_machine
}
