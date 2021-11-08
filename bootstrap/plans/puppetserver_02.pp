# This plan is a part of bootstrap::all and represents the second steps for the puppetserver
plan bootstrap::puppetserver_02 (
  TargetSpec $targets = 'puppetserver',
){
  # does not work, provider is not excepted in the right way
  # run_task('package', $targets, { 'action' => 'install', 'name' => 'r10k', 'provider' => 'puppet_gem' })

  run_command('puppet resource package r10k ensure=installed provider=puppet_gem', $targets)
  run_task('package', $targets, { action => 'install', name => 'git' })

  # configure r10k and control-repo
  apply($targets) {
    file { '/etc/puppetlabs/r10k':
      ensure  => directory,
    }

    file { '/var/cache/r10k':
      ensure  => directory,
    }

    $r10k_yaml = [
      '---',
      ":cachedir: '/var/cache/r10k'",
      ':sources:',
      '  :puppet:',
      "    remote: 'https://github.com/rwaffen/pupin-control.git'",
      "    basedir: '/etc/puppetlabs/code/environments'",
    ]

    file { '/etc/puppetlabs/r10k/r10k.yaml':
      ensure  => file,
      content => join($r10k_yaml, "\n"),
    }
  }

  # deploy puppetfile
  run_command('/opt/puppetlabs/puppet/bin/r10k deploy environment -p', $targets)
}
