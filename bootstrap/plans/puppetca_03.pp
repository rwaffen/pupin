plan bootstrap::puppetca_03 (
  TargetSpec $targets = 'puppetca',
){
  # Disable autosign on puppetca
  run_task('puppet_conf', 'puppetca',
    {
      action  => 'set',
      section => 'server',
      setting => 'autosign',
      value   => 'false',
    }
  )

  run_task('service', $targets, { action => 'restart', name => 'puppetserver' })
}
