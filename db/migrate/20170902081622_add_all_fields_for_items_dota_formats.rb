class AddAllFieldsForItemsDotaFormats < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :ui_id, :string
    add_column :items, :i_market_hash_name, :string
    add_column :items, :i_market_name, :string
    add_column :items, :i_name, :string
    add_column :items, :i_name_color, :string
    add_column :items, :i_rarity, :string
    add_column :items, :ui_status, :integer
    add_column :items, :he_name, :string
    add_column :items, :ui_price, :integer
    add_column :items, :min_price, :integer
    add_column :items, :ui_price_text, :boolean
    add_column :items, :min_price_text, :boolean
    add_column :items, :i_classid, :string
    add_column :items, :i_instanceid, :string
    add_column :items, :ui_new, :boolean
    add_column :items, :position, :integer
    add_column :items, :wear, :string
    add_column :items, :tradable, :integer
    add_column :items, :i_market_price, :float
    add_column :items, :i_market_price_text, :string
  end
end
