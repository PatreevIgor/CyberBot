class AddFieldsToTableItems < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :ui_real_instance, :string
    add_column :items, :ui_bid, :string
    add_column :items, :ui_asset, :string
    add_column :items, :type, :string
    add_column :items, :offer_live_time, :integer
    add_column :items, :placed, :string
  end
end
