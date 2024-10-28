source "https://artifactory.umn.edu/artifactory/api/gems/asr-rubygems" do
  ruby "~> 3.2"

  gem "activesupport", "~> 6.1"
  gem "i18n", "~> 1.14"
  gem "nokogiri", "~> 1.10"
  gem "rake", "~> 12.3"
  gem "whenever", require: false

  group :development, :test do
    gem "rspec", "~> 3.2"
  end

  group :development do
    gem "bundler-audit"
    gem "capistrano", "= 3.16.0"
    gem "capistrano-bundler", "~> 1.1"
    gem "standard", "~> 1.41"
    gem "reek", "~> 6.3"
  end
end
