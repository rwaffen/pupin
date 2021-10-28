plan bootstrap::puppetca_01 (
  TargetSpec $targets = 'puppetca',
){
  run_task('package', $targets, { 'action' => 'install', 'name' => 'puppetserver' })

  # allow allow-subject-alt-name for the setup, will be disabled later
  apply($targets) {
    $ca_conf = [
      'certificate-authority: {',
      '    allow-subject-alt-names: true',
      '    # allow-authorization-extensions: false',
      '    # enable-infra-crl: false',
      '}',
    ]

    file { '/etc/puppetlabs/puppetserver/conf.d/ca.conf':
      ensure  => file,
      content => join($ca_conf, "\n"),
    }
  }

  # set server to one self for the first run
  run_task('puppet_conf', $targets,
    {
      'action'  => 'set',
      'section' => 'agent',
      'setting' => 'server',
      'value'   => 'puppetca.priv.rw.example42.cloud',
    }
  )

  # allow autosign for the setup
  run_task('puppet_conf', $targets,
    {
      'action'  => 'set',
      'section' => 'server',
      'setting' => 'autosign',
      'value'   => 'true',
    }
  )

  run_task('service', $targets, { 'action' => 'start', 'name' => 'puppetserver'})
}
