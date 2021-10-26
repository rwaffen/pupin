plan bootstrap::puppetca_02 (
  TargetSpec $targets = 'puppetca',
){
  apply($targets) {
    $ca_conf = [
      'certificate-authority: {',
      '    allow-subject-alt-names: false',
      '    # allow-authorization-extensions: false',
      '    # enable-infra-crl: false',
      '}',
    ]

    file { '/etc/puppetlabs/puppetserver/conf.d/ca.conf':
      ensure  => file,
      content => join($ca_conf, "\n"),
    }
  }

  $puppet_conf =  {
    'certname'      => 'puppetca.priv.rw.example42.cloud',
    'server'        => 'puppet.priv.rw.example42.cloud',
    'ca_server'     => 'puppetca.priv.rw.example42.cloud',
  }

  $puppet_conf.each |$setting, $value| {
    run_task('puppet_conf', $targets, "Setting: ${setting}",
    {
      'action'  => 'set',
      'section' => 'agent',
      'setting' => $setting,
      'value'   => $value,
      }
    )
  }

  run_task('service', $targets, { 'action' => 'restart', 'name' => 'puppetserver'})
}
