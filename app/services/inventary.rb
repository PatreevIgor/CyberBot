module Inventary
  STATUS_NOT_SALE_ITEMS = 'not sale'.freeze
  STATUS_SALE_ITEMS     = 'sale on'.freeze

  def update_not_sale_items
    Item.all.where(status: STATUS_NOT_SALE_ITEMS).delete_all
    create_not_sale_items
  end

  def update_sale_items
    Item.all.where(status: STATUS_SALE_ITEMS).delete_all
    create_sale_items
  end

  def create_not_sale_items
    not_sale_items.each do |ok_or_data, items|
      if ok_or_data == 'data'
        items.each do |item_attr|
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
                      i_classid:           item_attr['i_classid'],
                      i_instanceid:        item_attr['i_instanceid'],
                      ui_new:              item_attr['ui_new'],
                      position:            item_attr['position'],
                      wear:                item_attr['wear'],
                      tradable:            item_attr['tradable'],
                      i_market_price:      item_attr['i_market_price'], 
                      i_market_price_text: item_attr['i_market_price_text'],
                      link:                item_link(item_attr['i_classid'],
                                                     item_attr['i_instanceid'],
                                                     item_attr['i_market_hash_name']),
                      status:              STATUS_NOT_SALE_ITEMS)
        end
      end
    end
  end

  def create_sale_items
    sale_items.each do |success_or_offers, items|
      if success_or_offers == 'offers'
        items.each do |item_attr|
          Item.create(ui_id:               item_attr['ui_id'],
                      i_name:              item_attr['i_name'],
                      i_market_name:       item_attr['i_market_name'],
                      i_name_color:        item_attr['i_name_color'],
                      i_rarity:            item_attr['i_rarity'],
                      ui_status:           item_attr['ui_status'],
                      he_name:             item_attr['he_name'],
                      ui_price:            item_attr['ui_price'],
                      i_classid:           item_attr['i_classid'],
                      i_instanceid:        item_attr['i_instanceid'],
                      ui_real_instance:    item_attr['ui_real_instance'],
                      i_market_price:      item_attr['i_market_price'],
                      position:            item_attr['position'],
                      min_price:           item_attr['min_price'], 
                      ui_bid:              item_attr['ui_bid'], 
                      ui_asset:            item_attr['ui_asset'], 
                      type_new:            item_attr['type'], 
                      ui_price_text:       item_attr['ui_price_text'],
                      i_market_price_text: item_attr['i_market_price_text'],
                      offer_live_time:     item_attr['offer_live_time'],
                      placed:              item_attr['placed'],
                      i_market_hash_name:  item_attr['i_market_hash_name'],
                      link:                item_link(item_attr['i_classid'],
                                                     item_attr['i_instanceid'],
                                                     item_attr['i_market_hash_name']),
                      status:              STATUS_SALE_ITEMS)
        end
      end
    end
  end

  private

  def not_sale_items
    Connection.send_request(NOT_SALE_ITEMS_URL)
  end

  def sale_items
    Connection.send_request(SALE_ITEMS_URL)
  end

  def item_link(i_classid, i_instanceid, i_market_hash_name)
    "https://market.dota2.net/item/#{i_classid}-#{i_instanceid}-#{i_market_hash_name.gsub(' ','+')}/"
  end
end
