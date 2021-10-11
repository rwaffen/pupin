#!/bin/sh

puppet resource package puppetserver ensure=present
puppet resource service puppetserver ensure=running enable=true
