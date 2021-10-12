plan bootstrap::puppetconf (
  TargetSpec $targets,
  Boolean $external_ca = false,
){
  $puppet_conf =  {
    'environment'        => 'production',
    'splay'              => 'true',
    'use_cached_catalog' => 'false',
    'usecacheonfailure'  => 'false',
    'server'             => 'puppet.private.example42.cloud',
  }

  if $external_ca {
    $_puppet_conf = merge($puppet_conf, { 'ca_server' => 'puppetca.private.example42.cloud' })
  } else {
    $_puppet_conf = $puppet_conf
  }

  $_puppet_conf.each |$setting, $value| {
    run_task('puppet_conf', $targets, "Setting: ${setting}",
    {
      'action'  => 'set',
      'section' => 'agent',
      'setting' => $setting,
      'value'   => $value,
      }
    )
  }
}
