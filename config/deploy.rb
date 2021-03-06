# set :application, "set your application name here"
# set :repository,  "set your repository location here"

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

# role :web, "your web-server here"                          # Your HTTP server, Apache/etc
# role :app, "your app-server here"                          # This may be the same as your `Web` server
# role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
# role :db,  "your slave db-server here"

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end

require 'bundler/capistrano' # for bundler support

set :application, "pizza"
set :repository,  "git@github.com:flatiron-school/syllaboss.git"

set :user, 'chrisgonzgonz'
set :deploy_to, "/home/#{ user }/#{ application }"
set :use_sudo, false

set :shared_children, shared_children + %w{public/uploads}
set :shared_children, shared_children + %w{app/assets/images/videos}

set :scm, :git

default_run_options[:pty] = true

role :web, "192.241.176.105"                          # Your HTTP server, Apache/etc
role :app, "192.241.176.105"                          # This may be the same as your `Web` server

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  task :symlink_config, :roles => :app do 
    run "ln -nfs #{shared_path}/config/application.yml #{current_release}/config/application.yml"
  end
end

# Load assets here and create symlinks.
after 'deploy:update_code','deploy:symlink_config'