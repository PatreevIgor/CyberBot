module UpdateStatus
  STATUS_MAIN_ITEMS                = 'main'.freeze
  STATUS_ACTUALLY_MAIN_ITEMS       = 'main_actually'.freeze
  STATUS_NOT_ACTUALLY_MAIN_ITEMS   = 'main_not_actually'.freeze
  KEY_MIN_PRICE_OF_HASH_ITEM_INFO  = 'min_price'.freeze

  def update_status
    all_main_items = Item.where(status:STATUS_MAIN_ITEMS) +
                     Item.where(status:STATUS_ACTUALLY_MAIN_ITEMS) +
                     Item.where(status:STATUS_NOT_ACTUALLY_MAIN_ITEMS)
    all_main_items.each do |item|
      if coefficient_profit(best_offer_price(best_buy_offer_url(item.class_id,item.instance_id)),
                            best_offer_price(best_sell_offer_url(item.class_id,item.instance_id)),
                            2000) == true &&
         coefficient_current_state_of_prices(params_for_coeff_curr_st_of_pr(item)) > 1
        item.status = STATUS_ACTUALLY_MAIN_ITEMS
        item.price  = current_price(item.class_id, item.instance_id)
        item.save!
      else
        if item.status == STATUS_ACTUALLY_MAIN_ITEMS or item.status == STATUS_MAIN_ITEMS
          item.status = STATUS_NOT_ACTUALLY_MAIN_ITEMS
          item.save!
        end
      end
    end
  end

  private

  def params_for_coeff_curr_st_of_pr(item)
    {:class_id      => item.class_id,
     :instance_id   => item.instance_id,
     :current_price => current_price(item.class_id, item.instance_id),
     :hash_name     => item.hash_name}
  end

  def current_price(class_id, instance_id)
    item_informations(class_id, instance_id)[KEY_MIN_PRICE_OF_HASH_ITEM_INFO].to_f / 100
  end

  def item_informations(class_id, instance_id)
    Connection.send_request(item_informations_url(class_id, instance_id))
  end

  def item_informations_url(class_id, instance_id)
    "https://market.dota2.net/api/ItemInfo/#{class_id}_#{instance_id}/ru/?key="\
    "#{Rails.application.secrets.your_secret_key}"
  end
end
