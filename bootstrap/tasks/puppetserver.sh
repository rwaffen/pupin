#!/bin/sh

puppet resource package puppetserver ensure=present
puppet resource package r10k ensure=present provider=puppet_gem
puppet resource service puppetserver ensure=running enable=true
