# See http://unicorn.bogomips.org/Unicorn/Configurator.html for complete documentation.

# Use at least one worker per core if you're on a dedicated server,
# more will usually help for _short_ waits on databases/caches.
worker_processes <%= p('unicorn.worker_processes') %>

# Help ensure your application will always spawn in the "current" directory
working_directory '/var/vcap/packages/cf-containers-broker'

# listen on a TCP port
listen <%= p('port') %>, :tcp_nopush => true

# nuke workers after 120 seconds instead of 60 seconds (the default)
timeout 120

# By default, the Unicorn logger will write to stderr.
# Additionally, ome applications/frameworks log to stderr or stdout,
# so prevent them from going to /dev/null when daemonized here:
stderr_path '/var/vcap/data/cf-containers-broker/tmp/logs/cf-containers-broker.stderr.log'
stdout_path '/var/vcap/data/cf-containers-broker/tmp/logs/cf-containers-broker.stdout.log'

# combine Ruby 2.0.0dev or REE with "preload_app true" for memory savings
# http://rubyenterpriseedition.com/faq.html#adapt_apps_for_cow
preload_app true
GC.respond_to?(:copy_on_write_friendly=) and GC.copy_on_write_friendly = true
