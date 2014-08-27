role :web, "TBD.wh.reachlocal.com"
role :web_ctrl, "TBD.wh.reachlocal.com", :no_release => true

set :rails_env, "qa"
set :user, 'appuser'
set :deploy_to, "/rl/product/capture/apps/#{application}"
