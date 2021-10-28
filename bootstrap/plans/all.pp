plan bootstrap::all (
  TargetSpec $targets = ['puppet', 'puppetdb', 'puppetca', 'agent01'],
){
  # prepare puppet agent
  run_task('puppet_agent::install', $targets)

  # set hostname
  # now also set in terraform
  # run_plan('bootstrap::set_hostname', $targets)

  # install locales
  # run_task('package', $targets, { 'action' => 'install', 'name' => 'glibc-langpack-en' })
  run_task('package', $targets, { 'action' => 'install', 'name' => 'glibc-langpack-de' })

  # bootstrap ca
  # run_plan('bootstrap::puppetca_01')
  # run_plan('bootstrap::puppetserver_01')
  # run_plan('bootstrap::puppetca_02')
  # run_plan('bootstrap::puppetserver_02')
  run_plan('bootstrap::puppetdb_01')

  # Disable autosign on puppetca
  run_task('puppet_conf', 'puppetca',
    {
      'action'  => 'set',
      'section' => 'server',
      'setting' => 'autosign',
      'value'   => 'false',
    }
  )

  run_task('service', 'puppetca', { 'action' => 'restart', 'name' => 'puppetserver'})
}
