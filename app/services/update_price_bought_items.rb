module UpdatePriceBoughtItems
  def update_price_bought_items
    Items.where("price_of_buy > ?", 30)
  end
end
