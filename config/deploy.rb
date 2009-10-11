set :application, "greedyfoodie.com"

# git
default_run_options[:pty] = true
set :repository,  "git@github.com:benaldred/soapboxes.git"
set :scm, "git"
set :user, "deploy"
set :port, 10000
set :branch, "greedyfoodie"

ssh_options[:keys] = "#{ENV['HOME']}/.ssh/deploy"
ssh_options[:forward_agent] = true
# ssh_options[:verbose] = :debug

set :deploy_to, "/var/www/sites/#{application}"


role :app, application
role :web, application 
role :db,  application, :primary => true