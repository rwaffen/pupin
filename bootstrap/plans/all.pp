# This plan installs a puppetserver, puppetca and puppetdb
plan bootstrap::all (
  TargetSpec $targets      = ['puppetserver', 'puppetdb', 'puppetca', 'agent01'],
  String $collection       = 'puppet7',
  Boolean $prerequirements = true,
){
  if $prerequirements {
    out::message('### perpare environment, installing puppet-agent')
    run_plan('bootstrap::prerequirements', $targets, { collection => $collection })
  }

  out::message('### initialize PuppetCA - Part 1')
  run_plan('bootstrap::puppetca_01', 'puppetca')

  out::message('### initialize Puppetserver - Part 1')
  run_plan('bootstrap::puppetserver_01', 'puppetserver')

  out::message('### initialize PuppetCA - Part 2')
  run_plan('bootstrap::puppetca_02', 'puppetca')

  out::message('### initialize Puppetserver - Part 2')
  run_plan('bootstrap::puppetserver_02', 'puppetserver')

  out::message('### initialize PuppetDB')
  run_plan('bootstrap::puppetdb_01', 'puppetdb')

  out::message('### initialize PuppetCA - Part 3')
  run_plan('bootstrap::puppetca_03', 'puppetca')
}
