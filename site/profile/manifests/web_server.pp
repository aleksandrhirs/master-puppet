class profile::web_server {
  package {'httpd':
    ensure => present
  }
}