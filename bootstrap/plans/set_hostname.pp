# This plan can be used to set a hostname via hostnamectl
plan bootstrap::set_hostname (
  TargetSpec $targets = ['puppetserver', 'puppetdb', 'puppetca', 'agent01'],
){
    $targets.each |$target| {
      run_task('bootstrap::set_hostname', $target, { host => $target })
  }
}
