source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.2'

gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'rails', github: 'rails/rails', branch: 'main'

gem 'importmap-rails', '>= 0.3.4'
gem 'stimulus-rails', '>= 0.4.0'
gem 'tailwindcss-rails', '>= 0.4.3'
gem 'turbo-rails', '>= 0.7.11'

gem 'jbuilder', '~> 2.7'

gem 'bootsnap', '>= 1.4.4', require: false

gem 'rexml'

group :development, :test do
  gem 'debug', '>= 1.0.0', platforms: %i[mri mingw x64_mingw]
end

group :development do
  gem 'web-console', '>= 4.1.0'
end

group :test do
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end
