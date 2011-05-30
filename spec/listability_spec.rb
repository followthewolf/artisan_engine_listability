require 'spec_helper'

describe ArtisanEngine::Listability do
  it "is an Engine" do
    ArtisanEngine::Listability::Engine.ancestors.should include Rails::Engine
  end

  it "extends ActiveRecord::Base with the has_listability macro method" do
    ActiveRecord::Base.should respond_to :has_listability
  end
  
  context "includes stylesheet expansions: " do
    context "artisan_engine: " do
      it "artisan_engine/listability/back" do
        ActionView::Helpers::AssetTagHelper.stylesheet_expansions[ :artisan_engine ]
        .should include "artisan_engine/listability/back"
      end
    end
  end
end

describe "ArtisanEngine::Listability Test/Development Environment" do
  it "initializes ArtisanEngine::Listability" do
    ArtisanEngine::Listability.should be_a Module
  end
  
  it "compiles its stylesheets into ArtisanEngine's stylesheets/artisan_engine/listability directory" do
    Compass.configuration.css_path.should == "#{ ArtisanEngine.root }/lib/generators/artisan_engine/templates/assets/stylesheets/artisan_engine/listability"
  end
  
  it "does not compile stylesheets during tests" do
    Sass::Plugin.options[ :never_update ].should be_true
  end
  
  it "compiles its javascripts into ArtisanEngine's javascripts/artisan_engine/listability directory" do
    Barista.output_root.should == Pathname.new( "#{ ArtisanEngine.root }/lib/generators/artisan_engine/templates/assets/javascripts/artisan_engine/listability" )
  end
end