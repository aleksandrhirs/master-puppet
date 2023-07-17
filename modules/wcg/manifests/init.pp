class wcg {

  file { '/opt/wordcloud':
    ensure => directory,
    before => File['wcg'],
  }

  file { 'wcg':
    path => "/opt/wordcloud/word-cloud-generator",
    source => "https://github.com/Fenikks/master-puppet/raw/production/word-cloud-generator",
    mode => "755",
    require => File['/opt/wordcloud'],
  }

  file { 'wordcloud_service':
    path => "/etc/systemd/system/wordcloud.service",
    source => "puppet:///modules/wcg/wordcloud.service",
    notify => Service['wordcloud'],
  }

  service { 'wordcloud':
    ensure => running,
    require => File['wordcloud_service'],
  }

}