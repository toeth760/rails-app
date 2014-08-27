role :web, "192.168.50.93"
role :web_ctrl, "192.168.50.93", :no_release => true

set :rails_env, "development"
set :user, 'appuser'
set :deploy_to, "/rl/product/capture/apps/#{application}"
