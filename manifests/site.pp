node default {
  notify { 'os_version':
    message   => "Running on ${facts['os']['name']} version ${facts['os']['release']}"
  }
}

node slave1.puppet {

  package { 'httpd':
    ensure    => installed,
  }

  file { '/var/www/html/index.html':
    ensure    => present,
    source    => "/vagrant/index.html",
  }

  exec { 'open-port-80':
    command   => '/usr/bin/firewall-cmd --add-port=80/tcp --permanent',
    path      => '/usr/bin',
  }

  exec { 'restart_firewalld':
    command   => '/usr/bin/systemctl restart firewalld',
    path      => '/usr/bin',
  }

  service { 'httpd':
    ensure    => running,
    enable    => true,
    require   => Package['httpd'],
  }
}

  include wcg

  package { ['httpd', 'php']:
    ensure    => installed,
  }

  file { '/var/www/html/index.php':
    ensure    => present,
    source    => '/vagrant/index.php',
  }

  file { '/var/www/html/index.html':
    ensure    => absent,
  }

  exec { 'open-port-80':
    command   => '/usr/bin/firewall-cmd --add-port=80/tcp --permanent',
    path      => '/usr/bin',
  }

  exec { 'restart_firewalld':
    command   => '/usr/bin/systemctl restart firewalld',
    path      => '/usr/bin',
  }

  service { 'httpd':
    ensure    => running,
    enable    => true,
    require   => Package['httpd'],
  }
}
