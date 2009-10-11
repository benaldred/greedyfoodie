#load custom recipes folder
Dir['config/capistrano/recipes/*.rb'].each { |r| load(r) }

# -----------
#	App
# -----------
set :application, "greedyfoodie.com"
set :deploy_to, "/var/www/sites/#{application}" 


# -----------
#	ssh
# -----------
default_run_options[:pty] = true
set :user, "deploy"
set :use_sudo, false   
set :port, 10000
#ssh_options[:keys] = "#{ENV['HOME']}/.ssh/deploy"
ssh_options[:forward_agent] = true
#ssh_options[:verbose] = :debug

# -----------
#	git
# -----------
set :repository, "git@github.com:benaldred/soapboxes.git"
set :scm, "git"
set :branch, "greedyfoodie"


role :app, application
role :web, application 
role :db,  application, :primary => true

# -----------
#	tasks
# -----------

namespace :deploy do
  
  desc "Restarting passenger with restart.txt"
  # set the restart to use passenger
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
 
  # override defauls so they do nothing.
  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
  
  task :do_symlinks, :roles => [:app] do
   # create a symbolic link to our directories in shared
   run "ln -s #{shared_path}/config/database.yml #{release_path}/config/database.yml"
   run "ln -s #{shared_path}/config/soapbox.yml #{release_path}/config/soapbox.yml"
  end
      
  after "deploy:update_code", 'deploy:do_symlinks' 
  after "deploy:setup", "passenger:nginx:setup" 
  
end

namespace :rails do
  desc "run some generic rails setup"
  task :setup do
    install_gems
  end
  
  desc "install the gems for the app"
  task :install_gems do
    run "cd #{current_path} && sudo rake RAILS_ENV=production gems:install"
  end
end