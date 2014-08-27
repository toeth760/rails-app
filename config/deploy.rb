require 'bundler/capistrano'

set :default_environment, {
  'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
}
set :application, "capture_dashboard"
set :repository,  "ssh://git@stash.lax.reachlocal.com/cap/capture_dashboard.git"
set :bundle_flags, "--deployment --quiet --binstubs --shebang ruby-local-exec"

# Set initial settings for multi-stage extensions and load the multi-stage
# extension. It is important that the 'stages' and 'default_stage' settings
# are set before the require of the extension. I know this is strange but that
# is just how the multistage extension is designed.
set :stages, %w(vm)
set :default_stage, "vm"
require 'capistrano/ext/multistage'

set :use_sudo, false

set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

before "deploy:graceful_restart","deploy:mk_pid_dir"
after "deploy:setup", "deploy:log_symlink"
# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"

namespace :deploy do
  desc "Restart unicorn"
  task :restart, :roles => :web_ctrl do
    deploy.graceful_restart
  end

  desc "Hard restart of unicorn"
  task :hard_restart, :roles => :web_ctrl do
    deploy.stop
    run "UNICORN_CHECK_COUNT=1; while [ -e /var/run/unicorn/capture_dashboard.pid -a $UNICORN_CHECK_COUNT -lt 30 ]; do sleep 2; let UNICORN_CHECK_COUNT++; done"
    deploy.start
  end

  desc "Pause for 5 minutes"
  task :pause, :roles => [:daemon_ctrl, :resque_ctrl, :web_ctrl] do
    puts "We are going to pause for 5 minutes to let our changes propagate"
    sleep 300
  end

  desc "Zero-downtime restart of Unicorn"
  task :graceful_restart, :roles => :web_ctrl do
    run "if [ -e /var/run/unicorn/capture_dashboard.pid ]; then kill -s USR2 `cat /var/run/unicorn/capture_dashboard.pid`; else cd #{current_path} ; bundle exec unicorn_rails -c config/unicorn.rb -E #{rails_env} -D; fi"
  end

  desc "Reload unicorn configurations"
  task :reload, :roles => :web_ctrl do
    run "if [ -e /var/run/unicorn/capture_dashboard.pid ]; then kill -s HUP `cat /var/run/unicorn/capture_dashboard.pid`; fi"
  end

  desc "Start unicorn"
  task :start, :roles => :web_ctrl do
    run "cd #{current_path} ; bundle exec unicorn_rails -c config/unicorn.rb -E #{rails_env} -D"
  end

  desc "Stop unicorn"
  task :stop, :roles => :web_ctrl do
    run "if [ -e /var/run/unicorn/capture_dashboard.pid ]; then kill -s QUIT `cat /var/run/unicorn/capture_dashboard.pid`; fi"
  end

  desc "Create symlink for log directory to /rl/data/shared/logs"
  task :log_symlink, :except => { :no_release => true } do
    run "if [ -d /rl/data/shared/logs/capture_dashboard ]; then rm -rf #{shared_path}/log && ln -sfT /rl/data/shared/logs/capture_dashboard #{shared_path}/log; fi"
  end

  desc "Create pid dir"
  task :mk_pid_dir, :roles => :web_ctrl do
    run "if [ ! -d #{shared_path}/pids ]; then mkdir #{shared_path}/pids; fi"
  end
end

require './config/boot'
require 'airbrake/capistrano'
