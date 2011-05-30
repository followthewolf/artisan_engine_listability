class ScopedListableModel < ActiveRecord::Base
  has_listability :within => :listable_model
  belongs_to :listable_model
end