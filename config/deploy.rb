# config valid for current version and patch releases of Capistrano
lock "~> 3.15.0"

set :application, "geoportal"
set :group,       "geoportal"

set :repo_url, "git@github.com:jhu-library-applications/geoblacklight.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/opt/geoportal"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

set :chruby_ruby, 'ruby-2.6.5'

set :passenger_restart_with_touch, true
set :passenger_roles, :web

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, "config/database.yml", "config/blacklight.yml", ".env"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/sockets", "public/system", ".bundle"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
set :ssh_options, { :forward_agent => true }

set :branch, ENV['BRANCH'] if ENV['BRANCH']

before "deploy:assets:precompile", "deploy:group_permissions"
before "deploy:assets:precompile", "deploy:yarn_install"

## Bundle options
set :bundle_roles, :all
set :bundle_path, -> { shared_path.join('bundle') }

namespace :deploy do
  task :group_permissions do
    on roles(:app, :web) do
      execute "chown -R #{ENV['CAP_USER']}:catalyst #{release_path}"
      execute "chmod -R g+w #{release_path}"
    end
  end

  desc 'Run rake yarn:install'
  task :yarn_install do
    on roles(:web) do
      within release_path do
        execute("cd #{release_path} && yarn install")
      end
    end
  end
end
