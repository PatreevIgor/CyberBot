module CheckItems
  STATUS_NEW_ITEMS          = 'new'.freeze
  MESSAGE_FOR_CONSOLE       = "Found #{Item.where(status: 'new').size} new items!".freeze
  KEY_CLASS_ID_ITEM_HASH    = 'classid'.freeze
  KEY_INSTANCE_ID_ITEM_HASH = 'instanceid'.freeze
  KEY_PRICE_ITEM_HASH       = 'price'.freeze
  KEY_HASH_NAME_ITEM_HASH   = 'hash_name'.freeze
  KEY_BEST_OFFER_ITEM_HASH  = 'best_offer'.freeze
  URL_LAST_50_PURCHASES     = 'https://market.dota2.net/history/json/'.freeze

  def get_any_items(from_price, to_price, coeff_val, count_item)
    loop do
      check_50_last_sales(from_price, to_price, coeff_val)
    break if Item.where(status: STATUS_NEW_ITEMS).size.to_i >= count_item.to_i
    end 
  end

  private

  def check_50_last_sales(from_price, to_price, coeff_val)
    last_50_purchases.each do |item_hash, empty_val|
      define_best_item(class_id:             item_hash[KEY_CLASS_ID_ITEM_HASH],
                       instance_id:          item_hash[KEY_INSTANCE_ID_ITEM_HASH],
                       current_price:        item_hash[KEY_PRICE_ITEM_HASH],
                       hash_name:            item_hash[KEY_HASH_NAME_ITEM_HASH],
                       from_price_input_val: from_price,
                       to_price_input_val:   to_price,
                       coeff_input_val:      coeff_val)
    end
  end

  def last_50_purchases
    Connection.send_request(URL_LAST_50_PURCHASES)
  end

  def define_best_item(params)
    if filter_conditions?(params)
      Item.create(class_id:        params[:class_id],
                  instance_id:     params[:instance_id],
                  hash_name:       params[:hash_name],
                  price:           params[:current_price],
                  link:            item_link(params[:class_id],
                                             params[:instance_id], 
                                             params[:hash_name]),
                  status:                    STATUS_NEW_ITEMS)
    else 
      send_message_to_console
    end
  end

  def filter_conditions?(params)
    if params[:current_price].to_f > min_price(params) &&
       params[:current_price].to_f > params[:from_price_input_val].to_i &&
       params[:current_price].to_f < params[:to_price_input_val].to_i &&
       item_not_exists?(params[:class_id], params[:instance_id], params[:hash_name]) &&
       item_profitability?(price_of_buy(params), price_of_sell(params), 2000)
      true
    else
      false
    end
  end

  def item_not_exists?(class_id, instance_id, hash_name)
    Item.exists?(:link => item_link(class_id, instance_id, hash_name)) ? false : true
  end

  def item_link(i_classid, i_instanceid, i_market_hash_name)
    "https://market.dota2.net/item/#{i_classid}-#{i_instanceid}-#{i_market_hash_name.gsub(' ','+')}/"
  end

  def item_profitability?(price_of_buy, price_of_sell, limit_of_benefit)
    clean_benefit = price_of_sell - price_of_buy - (price_of_sell  / 100 * 10)

    clean_benefit >= limit_of_benefit ? true : false
  end

  def price_of_buy(params)
    best_offer_price(best_buy_offer_url(params[:class_id], params[:instance_id]))
  end

  def price_of_sell(params)
    best_offer_price(best_sell_offer_url(params[:class_id], params[:instance_id]))
  end

  def best_offer_price(url)
    response = Connection.send_request(url)
    response['best_offer'].to_i
  end

  def best_buy_offer_url(class_id, instance_id)
    "https://market.dota2.net/api/BestBuyOffer/#{class_id}_#{instance_id}/?key="\
    "#{Rails.application.secrets.your_secret_key}"
  end

  def best_sell_offer_url(class_id, instance_id)
    "https://market.dota2.net/api/BestSellOffer/#{class_id}_#{instance_id}/?key="\
    "#{Rails.application.secrets.your_secret_key}"
  end

  def send_message_to_console
    puts MESSAGE_FOR_CONSOLE
  end
end
