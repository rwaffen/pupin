plan bootstrap::puppetdb_01 (
  TargetSpec $targets = 'puppetdb',
){
  # disable centos postgres stream to use postgres upstream repositoeries
  run_command('dnf module disable -y -q postgresql', $targets)
  run_command('dnf clean all', $targets)

  # set puppet conf
  $puppet_conf =  {
    'certname'      => 'puppetdb.priv.rw.example42.cloud',
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

  # run puppet on puppetdb and install/configure puppetdb
  run_plan('puppet_agent::run', $targets)

  # run puppet on puppetserver to use the puppetdb
  run_plan('puppet_agent::run', 'puppetserver')
}
