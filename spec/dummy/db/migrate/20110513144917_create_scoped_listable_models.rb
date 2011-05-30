class CreateScopedListableModels < ActiveRecord::Migration
  def self.up
    create_table :scoped_listable_models do |t|
      t.integer :position
      t.string :ancestry
      t.integer :listable_model_id

      t.timestamps
    end
  end

  def self.down
    drop_table :scoped_listable_models
  end
end
