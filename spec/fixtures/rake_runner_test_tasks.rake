require 'rake'
namespace :rake_runner_test_tasks do
  task :raise_error do |t|
    raise "error occurred"
  end

  task :success do |t|
    puts "hooray"
  end
end