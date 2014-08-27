class capture_dashboard::directories {
  file { '/var/run/unicorn':
    ensure  => directory,
    owner   => appuser,
    group   => appuser,
    mode    => '0777',
  }

  file { '/rl/':
    ensure  => directory,
    owner   => appuser,
    group   => appuser,
    mode    => '0755'
  }

  file { "/rl/product/":
    ensure  => directory,
    owner   => appuser,
    group   => appuser,
    mode    => '0755',
  }

  file { '/rl/data/':
    ensure  => directory,
    owner   => appuser,
    group   => appuser,
    mode    => '0755'
  }

  file { '/rl/data/shared/':
    ensure  => directory,
    owner   => appuser,
    group   => appuser,
    mode    => '0755'
  }

  file { '/rl/data/shared/configs/':
    ensure  => directory,
    owner   => appuser,
    group   => appuser,
    mode    => '0755'
  }

  file { '/rl/data/shared/logs/':
    ensure  => directory,
    owner   => appuser,
    group   => appuser,
    mode    => '0755'
  }
}
