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
      if coefficient_current_state_of_prices(params_for_coeff_curr_st_of_pr(item)) > 1 &&
         item_profitability?(best_offer_price(best_buy_offer_url(item.class_id,item.instance_id)),
                             best_offer_price(best_sell_offer_url(item.class_id,item.instance_id)),
                             1000)
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

  def coefficient_current_state_of_prices(params)
    if params[:current_price].to_f > middle_price(params)
      coefficient = 0
    else
      diff_middle_min = middle_price(params) - min_price(params)
      diff_middle_curr = params[:current_price].to_f - min_price(params)
      coefficient = 100 - diff_middle_curr * 100 / diff_middle_min
    end
    sprintf("%.2f", coefficient).to_f
  end

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



  def middle_price(params)
    min_middle_max_prices = get_hash_min_middle_max_prices(params)

    middle_price = min_middle_max_prices["average"].to_f
  end

  def max_price(params)
    min_middle_max_prices = get_hash_min_middle_max_prices(params)

    max_price = min_middle_max_prices["max"].to_f
  end

  def min_price(params)
    min_middle_max_prices = get_hash_min_middle_max_prices(params)

    min_price = min_middle_max_prices["min"].to_f
  end

  def get_hash_min_middle_max_prices(params)
    url = item_history_url(params[:class_id], params[:instance_id])
    response = Connection.send_request(url)

    create_hash_min_middle_max_prices(response)
  end

  def create_hash_min_middle_max_prices(response)
    min_middle_max_prices = {}

    if response["min"]
      min_middle_max_prices["min"] = response["min"]/100
    else
      min_middle_max_prices["min"] = 100/100
    end

    if response["max"] 
      min_middle_max_prices["max"] = response["max"]/100
    else
      min_middle_max_prices["max"] = 200/100
    end

    if response["average"] 
      min_middle_max_prices["average"] = response["average"]/100
    else
      min_middle_max_prices["max"] = 150/100
    end

    min_middle_max_prices
  end

  def item_history_url(class_id, instance_id)
    url = "https://market.dota2.net/api/ItemHistory/#{class_id.to_s}_#{instance_id.to_s}/?key="\
          "#{Rails.application.secrets.your_secret_key}"
  end
end
