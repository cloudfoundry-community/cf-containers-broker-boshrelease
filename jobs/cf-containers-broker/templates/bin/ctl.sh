#!/bin/bash

set -eu

cd /var/vcap/packages/cf-containers-broker
bundle exec unicorn \
        --daemonize \
        -c /var/vcap/jobs/cf-containers-broker/config/unicorn.conf.rb
