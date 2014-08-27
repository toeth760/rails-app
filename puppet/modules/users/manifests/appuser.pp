class users::appuser {

  require users::varpeople

  group { 'appuser':
    ensure    => 'present',
    gid       => '520',
    name      => 'appuser',
    provider  => 'groupadd',
    system    => true,
  }

  user { 'appuser':
    ensure      => 'present',
    gid         => '520',
    home        => '/var/people/appuser',
    managehome  => true,
    name        => 'appuser',
    provider    => 'useradd',
    shell       => '/bin/bash',
    system      => true,
    uid         => '520',
    comment     => 'application user',
  }

  file { '/var/people/appuser/.ssh':
    ensure      => 'directory',
    require     => User['appuser'],
    owner       => 'appuser',
    group       => 'appuser',
    mode        => '0700',
  }

  file { '/var/people/appuser/.ssh/id_dsa':
    ensure      => 'file',
    require     => User['appuser'],
    owner       => 'appuser',
    group       => 'appuser',
    mode        => '0600',
    source      => 'puppet:///modules/users/appuser.id_dsa',
  }

  file { '/var/people/appuser/.ssh/id_dsa.pub':
    ensure      => 'file',
    require     => User['appuser'],
    owner       => 'appuser',
    group       => 'appuser',
    mode        => '0600',
    source      => 'puppet:///modules/users/appuser.id_dsa.pub',
  }

  file { '/var/people/appuser/.ssh/known_hosts':
    ensure      => 'file',
    require     => User['appuser'],
    owner       => 'appuser',
    group       => 'appuser',
    mode        => '0600',
    source      => 'puppet:///modules/users/appuser.known_hosts',
  }

  file { '/var/people/appuser/.ssh/authorized_keys':
    ensure      => 'file',
    require     => User['appuser'],
    owner       => 'appuser',
    group       => 'appuser',
    mode        => '0600',
    source      => 'puppet:///modules/users/appuser.authorized_keys',
  }

  Group['appuser'] -> User['appuser']

  exec { "/usr/sbin/usermod -a -G vagrant appuser":
    require => Group['appuser'];
  }

  exec { "/usr/sbin/usermod -a -G appuser vagrant":
    require => Group['appuser'];
  }
}
