class ChangeTypeFieldsUiPriceAndUiPriceTextTableItems < ActiveRecord::Migration[5.1]
  def change
    change_column :items, :ui_price, :float
    change_column :items, :ui_price_text, :string
  end
end
