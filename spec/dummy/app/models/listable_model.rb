class ListableModel < ActiveRecord::Base
  has_listability
  has_many :scoped_listable_models
end
