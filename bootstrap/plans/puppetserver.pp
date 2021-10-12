plan bootstrap::puppetserver (
  TargetSpec $targets = 'puppetserver',
  Boolean $is_also_ca = true,
){
  if $is_also_ca {
    $ca = 'puppetlabs.services.ca.certificate-authority-service/certificate-authority-service'
  } else {
    $ca = 'puppetlabs.services.ca.certificate-authority-disabled-service/certificate-authority-disabled-service'
  }

  $watch = 'puppetlabs.trapperkeeper.services.watcher.filesystem-watch-service/filesystem-watch-service'

  apply($targets) {
    package { 'puppetserver':
      ensure => installed,
    }

    package { 'r10k':
      ensure   => installed,
      provider => 'puppet_gem',
    }

    file { '/etc/puppetlabs/puppetserver/services.d/ca.cfg':
      ensure  => file,
      content => join([$ca, $watch], "\n"),
    }

    ~> service { 'puppetserver':
      ensure => running,
      enable => true,
    }
  }
}
