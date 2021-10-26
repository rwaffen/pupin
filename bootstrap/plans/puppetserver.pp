plan bootstrap::puppetserver (
  TargetSpec $targets = 'puppetserver',
){
  $ca    = 'puppetlabs.services.ca.certificate-authority-disabled-service/certificate-authority-disabled-service'
  $watch = 'puppetlabs.trapperkeeper.services.watcher.filesystem-watch-service/filesystem-watch-service'

  run_task('puppet_conf', $targets, "Setting: ${setting}",
  {
    'action'  => 'set',
    'section' => 'agent',
    'setting' => 'server',
    'value'   => 'puppetca.private.example42.cloud',
    }
  )

  run_task('puppet', $targets)

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
