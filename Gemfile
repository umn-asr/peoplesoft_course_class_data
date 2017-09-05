source "https://artifactory.umn.edu/artifactory/api/gems/asr-rubygems" do

  gem 'nokogiri'
  gem 'activesupport', '~> 4.2.0'
  gem 'daemon-kit'
  gem 'rake'

  # daemon-kit changes
  gem 'rufus-scheduler', '~> 2.0'
  gem 'safely' # Optional, but recommended.
  # gem 'toadhopper' # For reporting exceptions to hoptoad
  gem 'mail' # For reporting exceptions via mail

  group :development, :test do
    gem 'rspec', '~> 3.2'
  end

  group :development do
    gem 'lastpassify'
    gem 'capistrano', '= 3.3.5'
    gem 'capistrano-bundler', '~> 1.1'
  end
end
