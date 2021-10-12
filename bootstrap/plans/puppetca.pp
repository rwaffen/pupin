plan bootstrap::puppetca (
  TargetSpec $targets = 'puppetca',
){
  apply($targets) {
    package { 'puppetserver':
      ensure => installed,
    }

    service { 'puppetserver':
      ensure => running,
      enable => true,
    }
  }
}
