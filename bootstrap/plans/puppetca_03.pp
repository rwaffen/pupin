# This plan is a part of bootstrap::all and represents the third steps for the puppetca
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
