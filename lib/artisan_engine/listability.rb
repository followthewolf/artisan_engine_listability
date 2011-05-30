require 'artisan_engine/core'
require 'artisan_engine/listability'

module ArtisanEngine
  module Listability

    # ------------------ Autoload Necessary Modules ------------------ #
    
    autoload :TestHelpers,    'artisan_engine/listability/test_helpers' if Rails.env.test?
    autoload :HasListability, 'artisan_engine/listability/has_listability'
    
    # ------------------------- Vroom vroom! ------------------------- #
    
    class Engine < Rails::Engine
      config.before_configuration do
        ActionView::Helpers::AssetTagHelper.register_stylesheet_expansion :artisan_engine => [ "artisan_engine/listability/back" ]
      end
      
      initializer 'extend ActiveRecord' do
        ActiveRecord::Base.class_eval { include ArtisanEngine::Listability::HasListability }
      end
    end

  end
end