require 'spec_helper'

describe ListableModel do
  let( :new_listable ) { ListableModel.new }

  before :each do
    @listable1 = ListableModel.create!
    @listable2 = ListableModel.create!
    @listable3 = ListableModel.create!
    @listable4 = ListableModel.create!
    @listable5 = ListableModel.create!
  end

  context "scopes: " do 
    describe "#in_position" do
      it "returns in order of ascending position" do
        @listable3.usurp :position => 2
        @listable2.usurp :position => 3
    
        ListableModel.in_position.all.should == [ @listable1, @listable3, @listable2, @listable4, @listable5 ]
      end
    end
  end
  
  context "before creating: " do
    context "if no other listable models of the same class exist" do
      before do
        ListableModel.destroy_all
      end
      
      it "sets its position to 1" do
        new_listable.save
        new_listable.position.should == 1
      end
    end
      
    context "if other listable models of the same class exist" do
      it "sets itself to the highest possible position" do
        new_listable.save
        new_listable.position.should == 6
      end
    end
  end
    
  context "before destroying: " do
    it "promotes all subordinates of the same class" do
      @listable3.destroy
      
      @listable1.reload.position.should == 1
      @listable2.reload.position.should == 2
      @listable4.reload.position.should == 3
      @listable5.reload.position.should == 4
    end
  end

  describe "#usurp" do
    before do
      @listable4.usurp :position => 3
    end
    
    it "promotes all subordinates, then sets its new position" do
      @listable1.reload.position.should == 1
      @listable2.reload.position.should == 2      
      @listable3.reload.position.should == 4
      @listable5.reload.position.should == 5
    end
    
    it "takes its new position and demotes its equal and subordinates of the same class" do
      @listable4.reload.position.should == 3
    end

    it "returns the newly placed record" do
      returned = @listable4.usurp :position => 3
      returned.should == @listable4
    end
  end
end