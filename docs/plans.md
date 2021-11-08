## List available bolt plans

```
bolt plan show
```

## Install all components with a plan

All in one installation of puppetserver, ca and a db

```
bolt plan run bootstrap::all
```

## WiP: Single plans

Set hostnames

```
bolt plan run bootstrap::set_hostname
```
