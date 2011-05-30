# ------------------ Configure Rails Environment ----------------- #

ENV[ 'RAILS_ENV' ] = 'test'

require File.expand_path( '../dummy/config/environment.rb',  __FILE__ )
require 'rspec/rails'

# ---------------------- Load Support Files ---------------------- #

require 'factory_girl'
require 'forgery'

include ArtisanEngine::Listability::TestHelpers

Dir[ "#{ File.dirname( __FILE__ ) }/support/**/*.rb" ].each { |f| require f }

# ----------------------- Configure RSpec ------------------------ #

RSpec.configure do |config|
  require 'rspec/expectations'
  config.include RSpec::Matchers
  config.mock_with :rspec
end