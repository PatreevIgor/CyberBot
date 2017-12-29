module Inventary
  def update_not_sale_items_in_my_db
    create_new_not_sale_items
    delete_old_not_sale_items
  end

  def update_sale_items_in_my_db
  end

  private

  def create_new_not_sale_items
    not_sale_items.each do |ok_or_data, items|
      if ok_or_data == 'data'
        items.each do |item_attr|
          unless Item.where(ui_id: item_attr['ui_id']).size >= 1
            Item.create(ui_id:               item_attr['ui_id'],
                        i_market_hash_name:  item_attr['i_market_hash_name'],
                        i_market_name:       item_attr['i_market_name'],
                        i_name:              item_attr['i_name'],
                        i_name_color:        item_attr['i_name_color'],
                        i_rarity:            item_attr['i_rarity'],
                        ui_status:           item_attr['ui_status'],
                        he_name:             item_attr['he_name'],
                        ui_price:            item_attr['ui_price'],
                        min_price:           item_attr['min_price'],
                        ui_price_text:       item_attr['ui_price_text'].to_s, 
                        min_price_text:      item_attr['min_price_text'], 
                        class_id:            item_attr['i_classid'],
                        instance_id:         item_attr['i_instanceid'],
                        ui_new:              item_attr['ui_new'],
                        position:            item_attr['position'],
                        wear:                item_attr['wear'],
                        tradable:            item_attr['tradable'],
                        i_market_price:      item_attr['i_market_price'], 
                        i_market_price_text: item_attr['i_market_price_text'],
                        link:      Constant::ITEM_LINK_URL % { class_id:           item_attr['i_classid'],
                                                               instance_id:        item_attr['i_instanceid'], 
                                                               i_market_hash_name: item_attr['i_market_hash_name'].gsub(' ','+') },
                        status:    Constant::NOT_SALE_ITEMS_STATUS)
          end
        end
      end
    end
  end

  def not_sale_items
    Connection.send_request(Constant::NOT_SALE_ITEMS_URL % { your_secret_key: Rails.application.secrets.your_secret_key })
  end

  def delete_old_not_sale_items
    mass_ui_ids = []

    not_sale_items.each do |ok_or_data, items|
      if ok_or_data == 'data'
        items.each do |item_attr|
          mass_ui_ids << item_attr['ui_id']
        end
      end
    end

    Item.where(status: Constant::NOT_SALE_ITEMS_STATUS).each do |item|
        item.destroy unless mass_ui_ids.include?(item.ui_id)
    end
  end

  def sale_items
    Connection.send_request(Constant::SALE_ITEMS_URL % { your_secret_key: Rails.application.secrets.your_secret_key })
  end
end
