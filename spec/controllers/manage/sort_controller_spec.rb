require 'spec_helper'

describe Manage::SortController do
  before do
    @l1 = ListableModel.create!
    @l2 = ListableModel.create!
    @l3 = ListableModel.create!
  end
  
  it "updates the positions of the models passed to it" do
    post 'sort', :type           => 'listable_models',
                 :listable_model => [ "#{ @l3.id }", 
                                      "#{ @l2.id }", 
                                      "#{ @l1.id }" ]
    
    @l1.reload.position.should == 3
    @l2.reload.position.should == 2
    @l3.reload.position.should == 1
  end
end