# config valid only for current version of Capistrano
lock '3.3.5'

set :application, 'peoplesoft_course_class_data'
set :repo_url, 'https://github.com/umn-asr/peoplesoft_course_class_data'
set :user, 'swadm'
set :roles, %w{app}
set :app_root, '/swadm/apps/peoplesoft_course_class_data'
set :deploy_to, "#{fetch(:app_root)}"

ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

set :linked_dirs, %w(tmp log vendor/bundle)
set :linked_files, %w{config/credentials.rb}

after "deploy:updated", :link_shared_tmp_folder do
  # link in the shared tmp folder
  on roles(:app) do
    execute "ln -nfs /swadm/tmp #{release_path}/json_tmp"
  end
end

after "deploy:finished", :reset_daemon do
  on roles(:app) do
    execute "cd #{release_path} && DAEMON_ENV=#{fetch(:stage)} bundle exec bin/peoplesoft_course_class_data stop && DAEMON_ENV=#{fetch(:stage)} bundle exec bin/peoplesoft_course_class_data start"
  end
end

