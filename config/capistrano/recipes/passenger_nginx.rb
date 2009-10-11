# ---------------------------------
#  slicehost capistrano recipes
# ---------------------------------

namespace :passenger do
  namespace :nginx do 
  
    #use on!
   set :use_sudo, true
   set :nginx_root, "/opt/nginx"
   
   task :setup do
    config_vhost
    restart
   end
  
    desc "Configure VHost for passenger"
    task :config_vhost do
      transaction do
        vhost_config =<<-EOF
server {
  listen 80;
  server_name #{application};
  root #{deploy_to}/current/public;
  passenger_enabled on;
}
    EOF
        put vhost_config, "#{deploy_to}/vhost_config"
        sudo "mv #{deploy_to}/vhost_config #{nginx_root}/sites-available/#{application}"
        sudo "chown root:root #{nginx_root}/sites-available/#{application}"
      end
    end
  
    desc "Restart Nginx"
    task :restart do
      sudo "/etc/init.d/nginx restart"
    end
  
    task :enable do
      sudo "ln -s #{nginx_root}/sites-available/#{application} #{nginx_root}/sites-enabled/#{application}" 
    end
    
    task :disable do
      sudo "rm #{nginx_root}/sites-enabled/#{application}" 
    end 
  end
end