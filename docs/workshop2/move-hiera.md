# how 2 infrastructure

# Assumptions

We should have the following structure, ore something similar:

```
cd Development

ls -la

drwxr-xr-x   - rwaffen  9 Nov  9:36 pupin
drwxr-xr-x   - rwaffen 19 Nov  9:18 pupin-control
```

## Move hiera to an own repository

1. Create a new repository at github or your favorite git server
2. Clone the repository

```
cd Development
git clone git@github.com:rwaffen/pupin-hiera.git

ls -la

drwxr-xr-x   - rwaffen  9 Nov  9:36 pupin
drwxr-xr-x   - rwaffen 19 Nov  9:18 pupin-control
drwxr-xr-x   - rwaffen  9 Nov  9:34 pupin-hiera
```

3. Move everything from `data/` to this new repository

```
cd pupin-control
mv data/* ../pupin-hiera
rm -rf data
```

4. Include the new repository in Puppefile. Best practice is to have it right after the initial `forge` line and before the first forge module.

```
# pupin-hiera
mod 'data',
  :git            => 'https://github.com/rwaffen/pupin-hiera.git',
  :branch         => :control_branch,
  :default_branch => 'main',
  :install_path   => '' # checkout hiera on environemnt root
```

This includes the pupin-hiera repository on the root oft the environment.
It is important to set `:install_path => ''`. Empty string is here a reference to the environment root.

The `mod` has to be `data`, because this will be the directory in which it will be cloned into.

The compile server should be abled to get the repository set in `:git`. So it maybe puplic or you have to provide credentials. In this example we use public repositories.

`:branch => :control_branch` means, that when you have a branch `development` in the pupin-control repo, r10k will search for the same branch name in pupin-hiera at a deployment and use/checkout this. If it doesn't find the branch, it will use the one specified at `:default_branch => 'main'`. Which than will be `main` in our example.

5. hiera.yaml in the pupin-control repository can be left ontouched.

6. The pupin-hiera should now look something like this:

```
cd pupin-hiera

find *

LICENSE
README.md
common.yaml
nodes/
nodes/example-node.yaml
nodes/puppetdb.priv.example42.cloud.yaml
```

7. Commit all changes.

```
cd pupin-hiera
git add -A
git commit -m 'initial commit'
git push
```

```
cd pupin-control
git add -A
git commit -m 'move hiera to its own repository'
git push
```

8. deploy changes to the compile master

```
ssh puppetdb.pub.example42.cloud -l root

/opt/puppetlabs/puppet/bin/r10k deploy environment -v -m
```

you should see now in the output that a module hiera is deployed.
But In the code dir should no change be visible.

```
cd /etc/puppetlabs/code/environments/production

ls -l

.rw-r--r--   22 root 18 Okt 18:51 -- CODEOWNERS
drwxr-xr-x    - root 19 Nov  9:32 -- data
.rw-r--r--  129 root 18 Okt 18:51 -- environment.conf
.rw-r--r--  180 root  8 Nov 15:36 -- hiera.yaml
.rw-r--r--  11k root 18 Okt 18:51 -- LICENSE
drwxr-xr-x    - root 19 Nov  9:32 -- manifests
.rw-r--r--  745 root 19 Nov  9:32 -- Puppetfile
.rw-r--r-- 7,4k root 18 Okt 18:51 -- README.md
drwxr-xr-x    - root 18 Okt 18:51 -- scripts
drwxr-xr-x    - root 19 Nov  9:32 -- site-modules
```

Thats it! Now we have hiera seperated into its own repository. We can now develop it independently from the control repo and/or have seperate access privileges on it.
