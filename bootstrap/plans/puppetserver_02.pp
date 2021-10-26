plan bootstrap::puppetserver_02 (
  TargetSpec $targets = 'puppetserver',
){
  run_task('package', $targets, { 'action' => 'install', 'name' => 'r10k', 'provider' => 'puppet_gem' })
  run_task('package', $targets, { 'action' => 'install', 'name' => 'git' })

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

  run_command('/opt/puppetlabs/puppet/bin/r10k deploy environment -p', $targets)
}
