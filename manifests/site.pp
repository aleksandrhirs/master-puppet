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

node slave2.puppet {

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

node master.puppet {

  class { 'nginx':
    manage_repo    => true,
    service_manage => true,
    service_ensure => 'running',
    service_enable => true,
  }

  file { '/etc/nginx/conf.d/nginx.conf':
    source    => '/vagrant/nginx.conf',
    ensure    => present,
  }

  ~> exec { 'nginx-restart':
    command     => '/usr/sbin/service nginx restart',
    refreshonly => true,
  }
}

node mineserver.puppet {

  package { 'java-17-openjdk-devel':
    ensure     => installed,
  }

  include minecraft
}
