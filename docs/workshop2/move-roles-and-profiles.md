# how 2 infrastructure

## Assumptions

We should have the following structure, ore something similar:

```
cd Development

ls -la

drwxr-xr-x   - rwaffen  9 Nov  9:36 pupin
drwxr-xr-x   - rwaffen 19 Nov  9:18 pupin-control
drwxr-xr-x   - rwaffen  9 Nov  9:34 pupin-hiera
```

## Create own repository

Create a new repository at github or your favorite git server.
Get upstream url.

For GitHub it could look like this: `git@github.com:rwaffen/pupin-infra.git`

## create new local PDK module

```
pdk new module
```

```
pdk (INFO): Creating new module:

We need to create the metadata.json file for this module, so we're going to ask you 5 questions.
If the question is not applicable to this module, accept the default option shown after each question. You can modify any answers at any time by manually updating the metadata.json file.

[Q 1/5] If you have a name for your module, add it here.
This is the name that will be associated with your module, it should be relevant to the modules content.
--> infra

[Q 2/5] If you have a Puppet Forge username, add it here.
We can use this to upload your module to the Forge when it's complete.
--> pupin

[Q 3/5] Who wrote this module?
This is used to credit the module's author.
--> Robert Waffen

[Q 4/5] What license does this module code fall under?
This should be an identifier from https://spdx.org/licenses/. Common values are "Apache-2.0", "MIT", or "proprietary".
--> BSD-3-Clause

[Q 5/5] What operating systems does this module support?
Use the up and down keys to move between the choices, space to select and enter to continue.
--> RedHat based Linux, Debian based Linux

Metadata will be generated based on this information, continue? Yes
pdk (INFO): Using the default template-url and template-ref.
pdk (INFO): Module 'infra' generated at path '/Users/rwaffen/Development/example42/company/pupin/infra'.
pdk (INFO): In your module directory, add classes with the 'pdk new class' command.
```

## Add remote to new pdk module

Initialise new local git repository.

```
cd infra
git init

# if new main branch is still named "master" please do this:
git branch -M main
```

Add upstream remot to the repository

```
git remote add origin git@github.com:rwaffen/pupin-infra.git
```

Check

```
git remote -v
```

Push local module to empty upstream repo

```
git add -A
git commit -m 'initial commit'
git push
```

## Move roles and profiles from control repository

Create role and profile directories in the local copy

```
cd manifests
mkdir -p roles profiles
```

Copy the code from control

```
cp -vr ../../pupin-control/site-modules/role/manifests/* roles
cp -vr ../../pupin-control/site-modules/profile/manifests/* profiles
```

Now edit every profile and replace in the class names `profile::` with `infra::profiles::`.
Now edit every role and replace in the class names `role::` with `infra::roles::`.

## Create init.pp

Create an entrypoint for the module by creating the main class.

```
pdk new class infra
```

```
---------------Files added--------------
/Users/rwaffen/Development/example42/company/pupin/infra/spec/classes/infra_spec.rb
/Users/rwaffen/Development/example42/company/pupin/infra/manifests/init.pp

----------------------------------------
```

## Add code for init.pp

The init.pp from infra will be our main entrypoint for puppet.
The first and only module to be loaded directly from control.

The code should look something like this.

```
class infra (
  Array $additional_profiles = [],
){
  include "infra::roles::${facts['role']}"

  # $additional_profiles.each |$profile| {
  #   include "infra::profiles::${profile}"
  # }
}
```

### External Facts

To classify oure nodes we can make use of external facts.
These we can use in puppet to assign roles in the entrypoint.

Place a yaml in `/etc/puppetlabs/facter/facts.d/` and it will be uses in facter and puppet runs.
These files are static. no scripts here.

```
mkdir -p /etc/puppetlabs/facter/facts.d/
cd /etc/puppetlabs/facter/facts.d/

# on puppet.priv.example42.cloud
echo "---\nrole: puppet::compiler"

# on agent01.priv.example42.cloud
echo "---\nrole: default"
```

We are using the roles class name after `infra::roles::` as fact `role`.
So we can do something like this in our infra/init.pp

```
include "infra::roles::${facts['role']}"
```

so we can auto-ssign the roles to the hosts.
But be warned, every host now must have a role fact, otherwise it will end in a broken puppet run.

## Update upstream

```
git add -A
git commit -m 'add roles and profiles from control'
git push
```

## Add infra to control again

Go to the control repo and open the `Puppetfile`.
Beneath the block where we included our hiera, we will now add the infra module.

```
mod 'infra', :git => 'https://github.com/rwaffen/pupin-infra.git', :branch => 'main'
```

After this open the `manifests/site.pp` in the control repository.
Remove all node definitions and update the default node that it looks like this:

```
node default {
  include infra
}
```

Now go to site-modules and delete the `role` and the `profile` directory.

Commit and push this to the control repository. After this trigger a r10k deployment on the compiler.

```
ssh puppet.pub.rw.example42.cloud -l root
/opt/puppetlabs/puppet/bin/r10k deploy environment -pv
```
