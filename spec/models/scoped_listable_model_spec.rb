require 'spec_helper'

describe ScopedListableModel do
  before do
    @parent1 = ListableModel.create!
      @child11 = @parent1.scoped_listable_models.create!
      @child12 = @parent1.scoped_listable_models.create!
      @child13 = @parent1.scoped_listable_models.create!
    
    @parent2 = ListableModel.create!
      @child21 = @parent2.scoped_listable_models.create!
      @child22 = @parent2.scoped_listable_models.create!
      @child23 = @parent2.scoped_listable_models.create!
  end
  
  context "scopes: " do
    context "#in_position" do
      context "if its scope model has a position attribute" do
        it "returns in order of ascending position per scope model" do
          @parent2.usurp :position => 1
          @child13.usurp :position => 2
      
          ScopedListableModel.in_position.all.should ==
            [ @child21, @child22, @child23, @child11, @child13, @child12 ]
        end
      end
    end
  end
  
  context "before creating: " do
    context "if no other scoped models of the same type exist in the scope" do
      it "sets its position to 1" do
        @child11.position.should == 1
        @child21.position.should == 1
      end
    end
    
    context "and other scoped models of the same type exist in the scope" do
      it "sets its position to the highest possible position in the scope" do
        @child12.position.should == 2
        @child13.position.should == 3
        
        @child12.position.should == 2
        @child23.position.should == 3
      end
    end
  end

  context "before destroying: " do
    it "promotes all subordinates of the same class in the scope" do
      @child12.destroy
      
      @child11.reload.position.should == 1
      @child13.reload.position.should == 2
      
      @child21.reload.position.should == 1
      @child22.reload.position.should == 2
      @child23.reload.position.should == 3
    end
  end
  
  describe "#usurp" do
    before do
      @child12.usurp :position => 1
    end
    
    it "promotes all subordinates in its scope, then sets its new position" do
      @child12.reload.position.should == 1
    end
      
    it "takes its new position and demotes its equal and subordinates of the same class in the scope" do
      @child11.reload.position.should == 2
      @child13.reload.position.should == 3
      
      @child21.reload.position.should == 1
      @child22.reload.position.should == 2
      @child23.reload.position.should == 3
    end
  end
  
end