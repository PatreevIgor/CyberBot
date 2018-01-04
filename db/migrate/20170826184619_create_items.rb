class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.integer :class_id
      t.integer :instance_id
      t.string  :hash_name
      t.integer :price
      t.float   :coefficient_profit
      
      t.timestamps
    end
  end
end
