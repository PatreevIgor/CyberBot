module UpdatePriceBoughtItems
  def update_price_bought_items # Должно устанавливаться когда инвентарь обновляешь
    
  end

  def set_min_price_of_sell
  end

  def fill_attr_price_of_buy_for_new_bought_items
    bught_items.each do |success_or_log, items|
      if success_or_log == 'log'
        items.each do |item|
          exist_items_in_db = Item.where(link: Constant::ITEM_LINK_URL % { 
                                                 class_id:           item['classid'],
                                                 instance_id:        item['instanceid'], 
                                                 i_market_hash_name: item['name'].gsub(' ','+') })

          exist_items_in_db.first.update_attributes(price_of_buy: item['price']) if exist_items_in_db.size >= 1
        end
      end
    end
  end

  def fill_attr_min_price_of_sell_for_new_bought_items
    Item.where('price_of_buy > ?', 30).each do |item|
      item.min_price_of_sell = sprintf("%.0f", min_favorable_price(item))
      item.save!
    end
  end

  def min_favorable_price(item)
    item.price_of_buy / 100 * 110 + 1000
  end

  def bught_items
    Connection.send_request(Constant::GET_ORDERS_LOG_URL % { your_secret_key: Rails.application.secrets.your_secret_key })
  end
end
