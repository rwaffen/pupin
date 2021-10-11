#!/bin/sh

puppet resource package puppetdb ensure=present
puppet resource service puppetdb ensure=running enable=true
