source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'
gem 'mimemagic', github: 'mimemagicrb/mimemagic', ref: '01f92d86d15d85cfd0f20dabd025dcbd36a8a60f'
gem 'rails', '~> 6.1.0'
gem 'sqlite3', '~> 1.4'
gem 'puma', '~> 5.0'
gem 'rack-cors', require: 'rack/cors'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'pg_lock'
gem 'graphql'
gem 'nokogiri', '~> 1.10.10'
gem "http"

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'listen', '~> 3.3'
  gem 'spring'
  gem 'pry-remote'
  gem 'graphiql-rails'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]