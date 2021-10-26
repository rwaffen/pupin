plan bootstrap::all (
  TargetSpec $targets = ['puppet', 'puppetdb', 'puppetca', 'agent01'],
){
  # prepare puppet agent
  run_task('puppet_agent::install', $targets)

  #set hostname
  $targets.each |$target| { run_task('bootstrap::set_hostname', $target) }

  # run_plan('bootstrap::puppetconf', $targets)

  run_plan('bootstrap::puppetca', 'puppetca')
  run_plan('bootstrap::puppetserver', 'puppetserver')
}
