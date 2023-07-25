class minecraft {
  file { '/opt/minecraft':
    ensure => directory,
  }

  exec { 'minecraft_server':
    command => '/usr/bin/curl -o /opt/minecraft/server.jar https://piston-data.mojang.com/v1/objects/84194a2f286ef7c14ed7ce0090dba59902951553/server.jar',
    creates => '/opt/minecraft/server.jar',
  }

  file { 'minecraft_service':
    path   => "/etc/systemd/system/minecraft.service",
    source => "puppet:///modules/minecraft/minecraft.service",
    notify => Service['minecraft'],
  }

  file { 'eula.txt':
    path   => "/opt/minecraft/eula.txt",
    source => "puppet:///modules/minecraft/eula.txt",
    notify => Service['minecraft'],
  }

  service { 'minecraft':
    ensure  => running,
    require => File['minecraft_service'],
  }
}