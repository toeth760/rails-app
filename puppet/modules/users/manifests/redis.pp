class users::redis {
  require users::varpeople

  group { 'redis':
    ensure    => 'present',
    gid       => '335',
    name      => 'redis',
    provider  => 'groupadd',
    system    => true,
  }

  user { 'redis':
    ensure      => 'present',
    gid         => '335',
    managehome  => false,
    name        => 'redis',
    provider    => 'useradd',
    system      => true,
    uid         => '335',
    comment     => 'redis user',
  }

  Group['redis'] -> User['redis']
}
