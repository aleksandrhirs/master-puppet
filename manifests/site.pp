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

  package { 'nginx':
    ensure    => 'installed',
  }

  file { '/etc/nginx/conf.d/nginx.conf':
    source    => '/vagrant/nginx.conf',
    ensure    => present,
  }

  service { 'nginx':
    ensure    => 'running',
    enable    => true,
  }
}

node mineserver.puppet {

  file { '/opt/minecraft':
    ensure => 'directory',
  }

  package { 'openjdk-8-jre-headless':
    ensure => installed,
  }

  exec { 'download_minecraft_server':
    command => 'curl -o /opt/minecraft/minecraft_server.jar https://piston-data.mojang.com/v1/objects/84194a2f286ef7c14ed7ce0090dba59902951553/server.jar',
    creates => '/opt/minecraft/minecraft_server.jar',
  }

  file { '/etc/systemd/system/minecraft.service':
    ensure  => file,
    content => template('/vagrant/minecraft.service.erb'),
  }

  file { '/etc/systemd/system/minecraft.service':
    content => template('/vagrant/minecraft.service.erb'),
    notify => Service['minecraft'],
  }

  service { 'minecraft':
    ensure => running,
    enable => true,
    require => [File['/opt/minecraft'], File['/etc/systemd/system/minecraft.service'], Exec['download_minecraft_server']],
  }
}
