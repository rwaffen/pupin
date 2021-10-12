plan bootstrap::puppetserver (
  TargetSpec $targets = 'puppetserver',
){
  $ca = [
    'puppetlabs.services.ca.certificate-authority-disabled-service/certificate-authority-disabled-service',
    'puppetlabs.trapperkeeper.services.watcher.filesystem-watch-service/filesystem-watch-service',
  ]

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
      content => join($ca, "\n"),
    }

    service { 'puppetserver':
      ensure => running,
      enable => true,
    }
  }
}
