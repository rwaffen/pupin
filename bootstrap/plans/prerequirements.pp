# This plan is a part of bootstrap::all and represents the steps which are pre required to run
plan bootstrap::prerequirements (
  TargetSpec $targets   = 'puppet',
  String $collection    = 'puppet7',
  Boolean $set_hostname = false,
  String $locale      = 'de',
){
  # install puppet agent
  run_task('puppet_agent::install', $targets, { collection => $collection })

  # set hostname
  if $set_hostname {
    run_plan('bootstrap::set_hostname', $targets)
  }

  # install locales to get working environment for yum and postgres
  run_task('package', $targets, { action => 'install', name => "glibc-langpack-${locale}" })
}
