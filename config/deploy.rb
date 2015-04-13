# config valid only for current version of Capistrano
lock '3.3.5'

set :application, 'peoplesoft_course_class_data'
set :repo_url, 'https://github.com/umn-asr/peoplesoft_course_class_data'

ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

set :linked_dirs, %w(log vendor/bundle)
set :linked_files, %w{config/initializers/environment_variables.rb}

after "deploy:updated", :link_shared_tmp_folder do
  # link in the shared tmp folder
  run "ln -nfs /swadm/tmp #{release_path}/tmp"
end

after "deploy:finished", :reset_daemon do
  run "DAEMON_ENV=#{stage} bundle exec #{release_path}/bin/peoplesoft_course_class_data"
end

