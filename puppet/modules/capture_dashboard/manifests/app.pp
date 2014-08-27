class capture_dashboard::app($user='', $homedir='') {
  file { "/rl/product/capture":
    ensure  => directory,
    owner   => "appuser",
    group   => "appuser",
    mode    => '0755',
    require => File['/rl/product'],
  }

  file { "/rl/product/capture/apps":
    ensure  => directory,
    owner   => "appuser",
    group   => "appuser",
    mode    => '0755',
    require => File['/rl/product/capture'],
  }

  file { "/rl/product/capture/apps/capture_dashboard":
    ensure  => directory,
    owner   => "appuser",
    group   => "appuser",
    mode    => '0755',
    require => File['/rl/product/capture/apps'],
  }

  file { "/rl/product/capture/apps/capture_dashboard/shared":
    ensure  => directory,
    owner   => "appuser",
    group   => "appuser",
    mode    => '0755',
    require => File['/rl/product/capture/apps/capture_dashboard'],
  }

  file { "/rl/product/capture/apps/capture_dashboard/shared/log":
    ensure  => directory,
    owner   => "appuser",
    group   => "appuser",
    mode    => '0775',
    require => File['/rl/product/capture/apps/capture_dashboard/shared'],
  }

  file { "${homedir}/.ssh/config":
    ensure => 'present',
    owner  => $user,
    group  => $user,
    mode   => '0644',
    source => "puppet:///modules/capture_dashboard/ssh_config",
  }

  file { "${homedir}/setup_app.sh":
    ensure  => 'present',
    owner   => $user,
    group   => $user,
    mode    => '0755',
    source  => "puppet:///modules/capture_dashboard/setup_app.sh",
  }

  file {"${vagrant_home}/bin":
    ensure => directory,
    owner => $vagrant_user,
    group => $vagrant_user,
  }

  file {"/etc/profile.d/set_timezone.sh":
    ensure => present,
    content => "TZ='America/Los_Angeles'; export TZ",
  }

  file { "/root/.ssh":
    ensure      => 'directory',
    mode        => '0700',
    owner       => 'root',
    group       => 'root',
  }

  file { "/root/.ssh/id_dsa":
    ensure      => 'file',
    mode        => '0600',
    owner       => 'root',
    group       => 'root',
    source      => 'puppet:///modules/users/appuser.id_dsa',
    require     => File['/root/.ssh'],
  }

  file { "/root/.ssh/config":
    ensure      => 'present',
    mode        => '0644',
    owner       => 'root',
    group       => 'root',
    source      => "puppet:///modules/capture_dashboard/ssh_config",
    require     => File['/root/.ssh'],
  }

  file { "${vagrant_home}/.ssh":
    ensure      => 'directory',
    owner       => $vagrant_user,
    group       => $vagrant_user,
    mode        => '0700',
  }

  file { "${vagrant_home}/.ssh/id_dsa":
    ensure      => 'file',
    owner       => $vagrant_user,
    group       => $vagrant_user,
    mode        => '0600',
    source      => 'puppet:///modules/users/appuser.id_dsa',
  }

  file { "${vagrant_home}/.ssh/id_dsa.pub":
    ensure      => 'file',
    owner       => $vagrant_user,
    group       => $vagrant_user,
    mode        => '0600',
    source      => 'puppet:///modules/users/appuser.id_dsa.pub',
  }
}
