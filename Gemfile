source 'http://rubygems.org'
gemspec

gem 'rake', '~> 0.8.7'

if ENV['BUNDLE_ENV'] == "dev"
	gem 'artisan_engine_core',	:path => '../core'
else
	gem 'artisan_engine_core',	:git => 'git@github.com:followthewolf/artisan_engine_core.git'
end