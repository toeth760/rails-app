class users::varpeople {
  file { '/var/people':
    ensure    => 'directory',
    mode      => '0755',
    owner     => 'root',
    group     => 'root',
  }
}