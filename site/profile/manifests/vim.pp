class profile::vim(
    $user_name = 'demouser',
){
  package { 'vim':
    ensure => present,
  }

  file { "/home/$user_name/.vimrc":
    ensure => file,
    content => 'set number',
    owner => $user_name,
    group => $user_name,
  }
}