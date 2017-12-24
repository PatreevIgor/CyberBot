class AddPriceOfBuyAndMinPriceOfSellFieldsToItemsModel < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :price_of_buy, :float
    add_column :items, :min_price_of_sell, :float
  end
end
