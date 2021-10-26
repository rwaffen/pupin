plan bootstrap::all (
  TargetSpec $targets = ['puppet', 'puppetdb', 'puppetca', 'agent01'],
){
  # prepare puppet agent
  # run_task('puppet_agent::install', $targets)

  # set hostname
  # run_plan('bootstrap::set_hostname', $targets)

  # bootstrap ca
  # run_plan('bootstrap::puppetca_01',     'puppetca')
  # run_plan('bootstrap::puppetserver_01', 'puppetserver')
  # run_plan('bootstrap::puppetca_02',     'puppetca')
  # run_plan('bootstrap::puppetserver_02', 'puppetserver')

run_task('package', 'puppetserver', { 'action' => 'install', 'name' => 'r10k', 'provider' => 'puppet_gem' })







  # run_task('puppet_conf', 'puppetca',
  #   {
  #     'action'  => 'set',
  #     'section' => 'server',
  #     'setting' => 'autosign',
  #     'value'   => 'false',
  #   }
  # )

  # run_task('service', 'puppetca', { 'action' => 'restart', 'name' => 'puppetserver'})
}
