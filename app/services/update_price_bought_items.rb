module UpdatePriceBoughtItems
  def update_price_bought_items # Должно устанавливаться когда инвентарь обновляешь
    Items.where("price_of_buy > ?", 30)
  end

  def set_min_price_of_sell
  end
end
