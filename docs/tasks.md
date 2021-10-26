## List available bolt tasks

```
bolt task show
```

## Terraform rampup

This is a bolt standard task, which uses the terraform manifests from `../terraform` directory.

```
bolt task run terraform::apply -t localhost dir="../terraform"
```


## Install Puppet Agent (latest)

This is a bolt standard task

```
bolt task run puppet_agent::install --targets puppet
```

## Set hostname

Set hostname via hostnamectl

```
bolt task run bootstrap::set_hostname --targets 'puppetserver' host='puppetserver'
```

## Tear down

This is a bolt standard task, which uses the terraform manifests from `../terraform` directory.

```
bolt task run terraform::destroy -t localhost dir="../terraform"
```
