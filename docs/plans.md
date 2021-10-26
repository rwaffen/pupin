## List available bolt plans

```
bolt plan show
```

## Install all components with a plan

WiP: All in one installation

```
bolt plan run bootstrap::all
```

## WiP: Single plans

Set hostnames

```
bolt plan run bootstrap::set_hostname
```

Available plans

```
bolt plan run bootstrap::puppetca
bolt plan run bootstrap::puppetconf
bolt plan run bootstrap::puppetserver
```
