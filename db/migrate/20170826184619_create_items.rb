class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.integer :class_id, :limit => 16
      t.integer :instance_id, :limit => 16
      t.string  :hash_name
      t.integer :price, :limit => 16
      t.float   :coefficient_profit, :limit => 16
      
      t.timestamps
    end
  end
end
