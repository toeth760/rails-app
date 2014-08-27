# config/unicorn.rb
# Set environment to development unless something else is specified
env = ENV["RAILS_ENV"] || "development"

# See http://unicorn.bogomips.org/Unicorn/Configurator.html for complete
# documentation.
worker_processes 2

# listen on both a Unix domain socket and a TCP port,
# we use a shorter backlog for quicker failover when busy
# listen "/tmp/my_site.socket", :backlog => 64

# Preload our app for more speed
preload_app true

# nuke workers after 30 seconds instead of 60 seconds (the default)
timeout 30

pid "/var/run/unicorn/capture_dashboard.pid"
listen '/var/run/unicorn/capture_dashboard.sock'

user 'appuser', 'appuser'
app_root = "/rl/product/capture/apps/capture_dashboard"
shared_path = "#{app_root}/shared"
current_working_directory = "#{app_root}/current"
# Help ensure your application will always spawn in the symlinked
# "current" directory that Capistrano sets up.
working_directory current_working_directory

stderr_path "#{shared_path}/log/unicorn.stderr.log"
stdout_path "#{shared_path}/log/unicorn.stdout.log"


before_fork do |server, worker|
  # the following is highly recomended for Rails + "preload_app true"
  # as there's no need for the master process to hold a connection
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end

  if defined?(Cequel::Model)
    Cequel::Model.keyspace.connection.disconnect! # kill the existing connections
    Cequel::Model.keyspace.clear_active_connections! # clear references to connection objects
  end

  # Before forking, kill the master process that belongs to the .oldbin PID.
  # This enables 0 downtime deploys.
  old_pid = "/var/run/unicorn/capture_dashboard.pid.oldbin"

  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

before_exec do |server|
  ENV['BUNDLE_GEMFILE'] = "#{current_working_directory}/Gemfile"
end

after_fork do |server, worker|
  # the following is *required* for Rails + "preload_app true",
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end

  # Note: There is no need to have a block like the following actually run
  # here to re-create the connection because the next time Cequel is used a
  # connection will be created for it.
  # if defined?(Cequel::Model)
  # end

  # if preload_app is true, then you may also want to check and
  # restart any other shared sockets/descriptors such as Memcached,
  # and Redis.  TokyoCabinet file handles are safe to reuse
  # between any number of forked children (assuming your kernel
  # correctly implements pread()/pwrite() system calls)

end
