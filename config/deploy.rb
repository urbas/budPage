# config valid only for current version of Capistrano
lock '3.3.5'

set :application, 'budpage'
set :repo_url, 'git@bitbucket.org:urbas/budpage.git'

# rbenv
set :rbenv_type, :user
set :rbenv_ruby, '2.1.5'

# Default server configuration
role :app, %w{budpage@54.154.215.159}
role :web, %w{budpage@54.154.215.159}
role :db, %w{budpage@54.154.215.159}

server '54.154.215.159', user: 'budpage', roles: %w{web app db}

set :ssh_options, {user: 'urbas',
                   keys: [ENV['HOME'] + '/.ssh/budpage_id_rsa'],
                   forward_agent: false,
                   auth_methods: %w(publickey)}


# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('bin', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')
set :linked_dirs, fetch(:linked_dirs, []).push('vendor/assets')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

task :stop_server do
  on roles(:web) do
    execute :sudo, :stop, fetch(:init_script)
  end
end

task :start_server do
  on roles(:web) do
    execute :sudo, :start, fetch(:init_script)
  end
end

namespace :deploy do
  desc "build missing paperclip styles"
  task :build_missing_paperclip_styles do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "paperclip:refresh:missing_styles"
        end
      end
    end
  end

  task :bower_install do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "bower:install['--force-latest']"
        end
      end
    end
  end
end

before("deploy:compile_assets", "deploy:bower_install")
after("deploy:compile_assets", "deploy:build_missing_paperclip_styles")

namespace :deploy do

  # after :published, :restart_server do
  #   on roles(:web) do
  #     # Here we can do anything such as:
  #     # within release_path do
  #     #   execute :rake, 'cache:clear'
  #     # end
  #   end
  # end

end