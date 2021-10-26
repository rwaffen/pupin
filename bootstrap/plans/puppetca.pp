plan bootstrap::puppetca (
  TargetSpec $targets = 'puppetca',
){
  run_task('package', $targets, { 'action' => 'install', 'name' => 'puppetserver' })
  run_task('bootstrap::ca_set_alt_names', $targets, { 'enable' => true })
  run_task('service', $targets, { 'action' => 'start', 'name' => 'puppetserver'})
}
