stage { 'req-install': before => Stage['app-install'] }
stage { 'app-install': require => Stage['req-install'] } 

exec { "apt-update":
  command => "/usr/bin/apt-get update"
}

Exec["apt-update"] -> Package <| |>

class requirements {
  include capture_dashboard::directories
  include users::appuser
  include packages::compiletools
}

class capture_dashboard {
  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/rvm/bin/"] }

  package {
    "rbenv":
    ensure => present,
    require => Exec['apt-update'],
  }

  rbenv::install { 'appuser':
    home => '/var/people/appuser',
    require => [Package['rbenv']],
  }

  rbenv::compile { 'appuser/2.0.0-p247':
    user => 'appuser',
    home => '/var/people/appuser',
    ruby => '2.0.0-p247',
    global => true,
    require => Rbenv::Install['appuser'],
  }

  #include packages::dse
  include packages::git
  include packages::rubydev
  include packages::rubygems
  include packages::rubybundler
  #include capture_dashboard::redis
  #include capture_dashboard::god

  class { 'capture_dashboard::app':
    user    => $vagrant_user,
    homedir => $vagrant_home,
  }

  include packages::phantomjs

  #if $role != "ci" { 
    #include capture_dashboard::rliapi
    #include capture_dashboard::web
  #}

  #Class['capture_dashboard::directories'] -> Class["packages::dse"] ->
  #Class["capture_dashboard::app"]
  Class['capture_dashboard::directories'] -> Class["capture_dashboard::app"]
}

class { 
  requirements: stage => "req-install";
  capture_dashboard: stage => "app-install"; 
}
