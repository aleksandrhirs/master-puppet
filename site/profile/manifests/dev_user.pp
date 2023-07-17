class profile::dev_user (
  $user_name = 'demouser',
  $passwd = '$1$pWicQEb0$lGXc.RyHF7VAG7tKOpIap1',
  $grps = ['puppetdemo']

){
# password is 'qwerty'

  group { $grps:
    ensure => present,
  }
  user { $user_name:
    ensure => present,
    managehome => true,
    groups => $grps,
    password => $passwd,
  }

}