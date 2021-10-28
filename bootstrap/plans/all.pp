plan bootstrap::all (
  TargetSpec $targets = ['puppet', 'puppetdb', 'puppetca', 'agent01'],
){
  # install puppet agent
  out::message('### perpare environment, installing puppet-agent')
  run_task('puppet_agent::install', $targets)

  # set hostname
  # run_plan('bootstrap::set_hostname', $targets)

  # install locales to get working environment for yum and postgres
  # run_task('package', $targets, { 'action' => 'install', 'name' => 'glibc-langpack-en' })
  run_task('package', $targets, { 'action' => 'install', 'name' => 'glibc-langpack-de' })

  out::message('### initialize PuppetCA - Part 1')
  run_plan('bootstrap::puppetca_01')

  out::message('### initialize Puppetserver - Part 1')
  run_plan('bootstrap::puppetserver_01')

  out::message('### initialize PuppetCA - Part 2')
  run_plan('bootstrap::puppetca_02')

  out::message('### initialize PuppetServer - Part 2')
  run_plan('bootstrap::puppetserver_02')

  out::message('### initialize PuppetDB')
  run_plan('bootstrap::puppetdb_01')


  # Disable autosign on puppetca
  out::message('### All done - disabling autosign')
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
