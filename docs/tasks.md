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

## Install Puppetserver

Use task from tasks/ directory to install puppetserver with puppet

```
bolt task run bootstrap::puppetserver --targets puppetserver
```

## Install PuppetCA

Use task from tasks/ directory to install puppetca with puppet

```
bolt task run bootstrap::puppetca --targets puppetca
```

## Install PuppetDB

Use task from tasks/ directory to install puppetdb with puppet

```
bolt task run bootstrap::puppetdb --targets puppetca
```

# Tear down

This is a bolt standard task, which uses the terraform manifests from `../terraform` directory.

```
bolt task run terraform::destroy -t localhost dir="../terraform"
```
