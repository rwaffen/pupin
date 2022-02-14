# how 2 infrastructure

## create Test Environment

```
cd pupin/bootstrap
bolt task run terraform::apply -t localhost dir="../terraform"
bolt task run puppet_agent::install --targets puppet
bolt task run package action=install name=glibc-langpack-de --targets puppet
```

## puppetca - bootstrap

```
ssh puppetca.pub.rw.example42.cloud -l root

puppet resource package puppetserver ensure=present
puppet config set --section agent server puppetca.priv.rw.example42.cloud

# enable allow-subject-alt-names
vi /etc/puppetlabs/puppetserver/conf.d/ca.conf

puppet resource service puppetserver ensure=running enable=true
```

## puppetserver - bootstrap

```
ssh puppet.pub.rw.example42.cloud -l root

puppet resource package puppetserver ensure=present

# disable ca
vi /etc/puppetlabs/puppetserver/services.d/ca.cfg

puppet config set --section agent ca_server puppetca.priv.rw.example42.cloud
puppet config set --section agent certname  puppet.priv.rw.example42.cloud
puppet config set --section agent server    puppetca.priv.rw.example42.cloud # set server first to puppetca
puppet config set --section agent dns_alt_names 'puppet.pub.rw.example42.cloud, puppet.priv.rw.example42.cloud, puppet'
puppet agent -t --waitforcert 10

# run on PuppetCA
puppetserver ca sign --certname puppet.priv.rw.example42.cloud

puppet config set --section agent server puppet.priv.rw.example42.cloud # set server to puppet
puppet resource service puppetserver ensure=running enable=true
```

## puppetca - set for production use

```
ssh puppetca.pub.rw.example42.cloud -l root

# disable allow-subject-alt-names
vi /etc/puppetlabs/puppetserver/conf.d/ca.conf

puppet config set --section agent ca_server puppetca.priv.rw.example42.cloud
puppet config set --section agent certname  puppetca.priv.rw.example42.cloud
puppet config set --section agent server    puppet.priv.rw.example42.cloud

systemctl restart puppetserver.service
```

## puppetserver - enable r10k

```
puppet resource package r10k ensure=present provider=puppet_gem
puppet resource package git ensure=present
mkdir -p /etc/puppetlabs/r10k /var/cache/r10k

vi /etc/puppetlabs/r10k/r10k.yaml

---
:cachedir: '/var/cache/r10k'
:sources:
  :puppet:
    remote: 'https://github.com/rwaffen/pupin-control.git'
    basedir: '/etc/puppetlabs/code/environments'

/opt/puppetlabs/puppet/bin/r10k deploy environment -pv
```

## puppetdb - bootstrap

```
ssh puppetdb.pub.rw.example42.cloud -l root

# disable app stream for postgresql, we use postgres upstream repos
dnf module disable -y -q postgresql && dnf clean all

# add server, ca_server and certname
puppet config set --section agent certname  puppetdb.priv.rw.example42.cloud
puppet config set --section agent server    puppet.priv.rw.example42.cloud
puppet config set --section agent ca_server puppetca.priv.rw.example42.cloud

# see control repo for node definition
puppet agent -t --waitforcert 10

# run on PuppetCA
puppetserver ca sign --certname puppetdb.priv.rw.example42.cloud
```

## puppetserver - use puppetdb

```
ssh puppet.pub.rw.example42.cloud -l root
puppet agent -t
```

## agent01 - bootstrap additional nodes

```
ssh agent01.pub.rw.example42.cloud -l root

# add server, ca_server and certname
puppet config set --section agent certname  agent01.priv.rw.example42.cloud
puppet config set --section agent server    puppet.priv.rw.example42.cloud
puppet config set --section agent ca_server puppetca.priv.rw.example42.cloud

# add role via csr

echo "---" > /etc/puppetlabs/puppet/csr_attributes.yaml
echo "extension_requests:" >> /etc/puppetlabs/puppet/csr_attributes.yaml
echo '  pp_role: "role::something"' >> /etc/puppetlabs/puppet/csr_attributes.yaml

puppet agent -t --waitforcert 10

# run on PuppetCA
puppetserver ca sign --certname agent01.priv.rw.example42.cloud
```
