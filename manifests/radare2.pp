# builds a radare box on debian 7 x86_64 with 32 bit compat 

class puppet_radare2::radare2 (

  $mortal     = $puppet_radare2::params::mortal,
  $mortal_key = $puppet_radare2::params::mortal_key,
  $r2domain   = $puppet_radare2::params::r2domain,
  $r2hname    = $puppet_radare2::params::r2hname,
  $timezone   = $puppet_radare2::params::timezone,

) inherits puppet_radare2::params {

  augeas { 'sshd_config':
    context => '/files/etc/ssh/sshd_config',
    changes => [
      'set PermitRootLogin no',
      'set PubkeyAuthentication yes',
      'set PasswordAuthentication no',
      'set ChallengeResponseAuthentication no',
      'set UsePAM no',
    ],
    notify  => Service['ssh'],
  }

  exec {'enable_32bit':
    command => 'dpkg --add-architecture i386 ; apt-get update',
    path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    unless  => 'dpkg --print-foreign-architectures |grep i386 2>/dev/null',
  }

  # install radare2 from git instead of stale debian package
  exec {'clone_radare2':
    creates => '/opt/radare2',
    command => 'git clone https://github.com/radare/radare2 /opt/radare2',
    notify  => Exec['build_radare2'],
    path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    require => Package['git'],
  }

  exec {'build_radare2':
    creates => '/usr/bin/radare2',
    cwd     => '/opt/radare2/sys',
    command => '/opt/radare2/sys/install.sh',
    path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    require => [ Package['gcc','make'], Exec['clone_radare2'] ],
    timeout => '0',
  }

  exec {'set_hostname':
    command     => 'hostname -F /etc/hostname',
    path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    refreshonly => true,
  }

  exec {'set_timezone':
    command     => 'dpkg-reconfigure --frontend noninteractive tzdata',
    path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    refreshonly => true,
  }

  file {'/etc/hostname':
    ensure  => file,
    content => $::hostname,
    group   => 'root',
    mode    => '0644',
    notify  => Exec['set_hostname'],
    owner   => 'root',
  }

  file {'/etc/timezone':
    ensure  => file,
    content => $timezone,
    group   => 'root',
    mode    => '0644',
    notify  => Exec['set_timezone'],
    owner   => 'root',
  }

  file {'vimrc':
    ensure  => present,
    content => 'set nocp',
    group   => $mortal,
    mode    => '0644',
    owner   => $mortal,
    path    => "/home/${mortal}/.vimrc",
    require => User['non_root'],
  }

  file {'radarerc':
    ensure  => present,
    group   => $mortal,
    mode    => '0644',
    owner   => $mortal,
    path    => "/home/${mortal}/.radarerc",
    require => User['non_root'],
    source  => 'puppet:///modules/puppet_radare2/radarerc',
  }

  file {'screenrc':
    ensure  => present,
    content => 'startup_message off',
    group   => $mortal,
    mode    => '0644',
    owner   => $mortal,
    path    => "/home/${mortal}/.screenrc",
    require => User['non_root'],
  }

  file {'/root/.vimrc':
    ensure  => present,
    content => 'set nocp',
    group   => 'root',
    mode    => '0644',
    owner   => 'root',
  }

  host {'fqdn':
    ensure       => present,
    host_aliases => $r2hname,
    ip           => $::ipaddress,
    name         => $r2domain,
  }

  package {'gcc': ensure => installed }
  package {'git': ensure => installed }

  package {'ia32-libs':
    ensure  => installed,
    require => Exec['enable_32bit'],
  }

  package {'ltrace':  ensure => installed }
  package {'make':    ensure => installed }
  package {'nasm':    ensure => installed }
  package {'screen':  ensure => installed }
  package {'strace':  ensure => installed }
  package {'tcpdump': ensure => installed }
  package {'unzip':   ensure => installed }

  service {'ssh':
    ensure => running,
    enable => true,
  }

  ssh_authorized_key {'non_root_key':
    ensure  => present,
    key     => $mortal_key,
    require => User['non_root'],
    type    => $mortal_keytype,
    user    => $mortal,
  }

  user {'non_root':
    ensure     => present,
    managehome => true,
    name       => $mortal,
    password   => '$6$03NeW5W2$GK.ztclBWolyM/D1s1nmtkm2fyZKtStRs5xYrHE3ew5Wuiz2DpHhj4p7.2RucrD1am/joIkBBRJcqbFC7Vyio.',
    shell      => '/bin/bash',
  }
}
