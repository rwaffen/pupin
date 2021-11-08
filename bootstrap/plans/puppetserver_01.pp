# This plan is a part of bootstrap::all and represents the first steps for the puppetserver
plan bootstrap::puppetserver_01 (
  TargetSpec $targets = 'puppetserver',
){
  run_task('package', $targets, { action => 'install', name => 'puppetserver' })

  $ca = [
    'puppetlabs.services.ca.certificate-authority-disabled-service/certificate-authority-disabled-service',
    'puppetlabs.trapperkeeper.services.watcher.filesystem-watch-service/filesystem-watch-service',
  ]

  # set server to ca for first run to get certificates
  $puppet_conf =  {
    certname      => 'puppet.priv.rw.example42.cloud',
    server        => 'puppetca.priv.rw.example42.cloud',
    ca_server     => 'puppetca.priv.rw.example42.cloud',
    dns_alt_names => 'puppet.pub.rw.example42.cloud, puppet.priv.rw.example42.cloud, puppet',
  }

  $puppet_conf.each |$setting, $value| {
    run_task('puppet_conf', $targets, "Setting: ${setting}",
      {
        action  => 'set',
        section => 'agent',
        setting => $setting,
        value   => $value,
      }
    )
  }

  # disable ca on server, we use an external ca
  apply($targets) {
    file { '/etc/puppetlabs/puppetserver/services.d/ca.cfg':
      ensure  => file,
      content => join($ca, "\n"),
    }
  }

  # run puppet to get certificates
  run_plan('puppet_agent::run', $targets)

  # switch puppet conf to oneself
  run_task('puppet_conf', $targets,
    {
      action  => 'set',
      section => 'agent',
      setting => 'server',
      value   => 'puppet.priv.rw.example42.cloud',
    }
  )

  run_task('service', $targets, { action => 'start', name => 'puppetserver'})
}
