#!/bin/bash

set -eu

source /var/vcap/packages/ruby-2*/bosh/runtime.env

export PATH=$PATH:/var/vcap/packages/cf-containers-broker/bin

export RAILS_ENV=production
export BUNDLE_GEMFILE=/var/vcap/packages/cf-containers-broker/Gemfile
export SETTINGS_PATH=/var/vcap/jobs/cf-containers-broker/config/settings.yml

mkdir -p /var/vcap/data/cf-containers-broker/tmp/logs
mkdir -p /var/vcap/data/cf-containers-broker/tmp/home
export HOME=/var/vcap/data/cf-containers-broker/tmp/home

# Proxy configuration
<% if_p('env.http_proxy') do |http_proxy| %>
export HTTP_PROXY="<%= http_proxy %>"
export http_proxy="<%= http_proxy %>"
<% end %>
<% if_p('env.https_proxy') do |https_proxy| %>
export HTTPS_PROXY="<%= https_proxy %>"
export https_proxy="<%= https_proxy %>"
<% end %>
<% if_p('env.no_proxy') do |no_proxy| %>
export NO_PROXY="<%= no_proxy %>"
export no_proxy="<%= no_proxy %>"
<% end %>

cd /var/vcap/packages/cf-containers-broker

<% if_p('fetch_images') do %>
# Fetch new/updated container images on restart
bundle exec fetch_container_images
<% end %>

<% if_p('update_containers') do %>
# Restart containers with latest image/config on restart
bundle exec update_all_containers
<% end %>

bundle exec unicorn \
        -c /var/vcap/jobs/cf-containers-broker/config/unicorn.conf.rb
