require 'rake'
namespace :rake_runner_test_tasks do
  task :raise_error do |t|
    raise "error occurred"
  end

  task :success do |t|
    puts "hooray"
  end

  task :sh_success do |t|
    sh "echo hooray"
  end
end