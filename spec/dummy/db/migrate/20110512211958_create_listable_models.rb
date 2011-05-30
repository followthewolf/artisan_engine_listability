class CreateListableModels < ActiveRecord::Migration
  def self.up
    create_table :listable_models do |t|
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :listable_models
  end
end
