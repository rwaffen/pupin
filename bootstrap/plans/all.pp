plan bootstrap::all (
  TargetSpec $targets = 'puppetserver, puppetca',
){
  # prepare puppet agent
  run_task('puppet_agent::install', $targets)
  run_plan('bootstrap::puppetconf', $targets)

  run_plan('bootstrap::puppetserver', 'puppetserver')
  run_plan('bootstrap::puppetca', 'puppetca')
}
