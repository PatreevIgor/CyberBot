module UpdatePriceBoughtItems
  def update_price_bought_items
    remove_all_trades
    puts Constant::REMOVED_ALL_TRADES_TEXT

    update_inventary
    puts Constant::WAIT_15_SEK_TEXT
    sleep 15

    update_not_sale_items_in_my_db
    puts Constant::NOT_SALE_ITEMS_UPDATED_TEXT

    fill_attr_price_of_buy_for_new_bought_items
    fill_attr_min_price_of_sell_for_new_bought_items
    puts Constant::FINISHED_FILLING_TEXT

    put_up_for_sale_bought_items
    puts Constant::PUT_UP_ALL_BOUGHT_ITEMS_TEXT
  end

private

def update_inventary
  Connection.send_request(Constant::UPDATE_INVENTARY_URL % { your_secret_key: Rails.application.secrets.your_secret_key })
end

def remove_all_trades
  Connection.send_request(Constant::REMOVE_ALL_URL % { your_secret_key: Rails.application.secrets.your_secret_key })
end


  def fill_attr_price_of_buy_for_new_bought_items
      bought_items.each do |success_or_log, items|
      if success_or_log == 'log'

        items.each do |item|
          exist_in_db_items = Item.where(link: Constant::ITEM_LINK_URL % { 
                                                          class_id:           item['classid'],
                                                          instance_id:        item['instanceid'], 
                                                          i_market_hash_name: item['name'].gsub(' ','+') })
          exist_in_db_items.each do |item_db|
            item_db.update_attributes(price_of_buy: item['price']) if exist_in_db_items.size >= 1
          end
        end
      end
    end
  end

  def bought_items
    Connection.send_request(Constant::GET_ORDERS_LOG_URL % { your_secret_key: Rails.application.secrets.your_secret_key })
  end

  def fill_attr_min_price_of_sell_for_new_bought_items
    Item.where('price_of_buy > ?', 30).each do |item|
      item.min_price_of_sell = sprintf("%.0f", min_favorable_price(item))
      item.save!
    end
  end

  def put_up_for_sale_bought_items
    all_inventary_items = Item.where(status: Constant::NOT_SALE_ITEMS_STATUS).order('i_name')
    all_inventary_items.each do |item|
      if item.price_of_buy == nil
        put_up_item_with_29_99(item)
      elsif item.price_of_buy != nil
        put_up_items_with_appropriate_price(item)
      end
    end
  end

  def put_up_item_with_29_99(item)
    Connection.send_request(Constant::SET_PRICE_URL % { ui_id:           item.ui_id,
                                                        price:           2999, 
                                                        your_secret_key: Rails.application.secrets.your_secret_key })
  end

  def put_up_items_with_appropriate_price(item)
    if min_price({ class_id: item.class_id, instance_id: item.instance_id }) == 1 &&
       max_price({ class_id: item.class_id, instance_id: item.instance_id }) == 2
      put_up_item_for_sale(item, min_favorable_price_for_only_items(item))
    elsif item_informations(item.class_id, item.instance_id)[Constant::ITEM_INFO_HASH_MIN_PRICE_KEY] == -1
      put_up_item_for_sale(item, max_price({ class_id: item.class_id, instance_id: item.instance_id }) * 100)
    else
      put_up_item_for_sale(item, appropriate_price(item))
    end
  end

  def put_up_item_for_sale(item, price)
    Connection.send_request(Constant::SET_PRICE_URL % { ui_id:           item.ui_id,
                                                        price:           price, 
                                                        your_secret_key: Rails.application.secrets.your_secret_key })
  end

  def appropriate_price(item)
    if min_price_of_orders_to_buy(item.class_id, item.instance_id) < min_favorable_price(item)
      min_favorable_price(item)
    else
      min_price_of_orders_to_buy(item.class_id, item.instance_id)
    end
  end

  def min_price_of_orders_to_buy(class_id, instance_id)
    item_informations(class_id, instance_id)[Constant::ITEM_INFO_HASH_MIN_PRICE_KEY].to_f - 0001
  end

  def min_favorable_price(item)
    sprintf("%.0f", (item.price_of_buy / 100 * 110 + 1000)).to_f
  end

  def min_favorable_price_for_only_items(item)
    item.price_of_buy / 100 * 110 + 3000
  end
end
