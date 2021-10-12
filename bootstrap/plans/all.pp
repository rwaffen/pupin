plan bootstrap::all (
  # TargetSpec $targets  = 'puppetserver, puppetca',
  Boolean $external_ca = false,
){
  if $external_ca {
    $targets = 'puppetserver, puppetca'
  } else {
    $targets = 'puppetserver'
  }
  # prepare puppet agent
  run_task('puppet_agent::install', $targets)
  run_plan('bootstrap::puppetconf', $targets, { 'external_ca' => $external_ca })


  if $external_ca {
    run_plan('bootstrap::puppetserver', 'puppetserver', { 'is_also_ca' => false })
    run_plan('bootstrap::puppetca', 'puppetca')
  } else {
    run_plan('bootstrap::puppetserver', 'puppetserver', { 'is_also_ca' => true })
  }
}
