module CheckItems
  # extend ActiveSupport::Concern 

  # included do
  #   scope :new_items, -> { where(status: NEW_ITEMS_STATUS) }
  # end

  NEW_ITEMS_STATUS          = 'new'.freeze
  ITEM_HASH_CLASS_ID_KEY    = 'classid'.freeze
  ITEM_HASH_INSTANCE_ID_KEY = 'instanceid'.freeze
  ITEM_HASH_PRICE_KEY       = 'price'.freeze
  ITEM_HASH_HASH_NAME_KEY   = 'hash_name'.freeze
  ITEM_HASH_BEST_OFFER_KEY  = 'best_offer'.freeze
  LAST_50_PURCHASES_URL     = 'https://market.dota2.net/history/json/'.freeze
  BEST_BUY_OFFER_URL        = 'https://market.dota2.net/api/BestBuyOffer/'\
                              '%{class_id}_%{instance_id}/?key=%{your_secret_key}'.freeze
  BEST_SELL_OFFER_URL       = 'https://market.dota2.net/api/BestSellOffer/'\
                              '%{class_id}_%{instance_id}/?key=%{your_secret_key}'.freeze
  ITEM_LINK                 = 'https://market.dota2.net/item/'\
                              '%{class_id}-%{instance_id}-%{i_market_hash_name}/'.freeze
  COUNT_FOUND_ITEMS_TEXT    = 'Found %{count_item} new items!'.freeze
  ITEM_CREATED_TEXT         = 'Item created!'.freeze

  def get_any_items(from_price, to_price, coeff_val, count_item)
    loop do
      check_50_last_sales(from_price, to_price, coeff_val)
    break if Item.where(status: NEW_ITEMS_STATUS).size.to_i >= count_item.to_i
    end 
  end

  private

  def check_50_last_sales(from_price, to_price, coeff_val)
    last_50_purchases.each do |item_hash, empty_val|
      define_best_item(class_id:             item_hash[ITEM_HASH_CLASS_ID_KEY],
                       instance_id:          item_hash[ITEM_HASH_INSTANCE_ID_KEY],
                       current_price:        item_hash[ITEM_HASH_PRICE_KEY],
                       hash_name:            item_hash[ITEM_HASH_HASH_NAME_KEY],
                       from_price_input_val: from_price,
                       to_price_input_val:   to_price,
                       coeff_input_val:      coeff_val)
    end
  end

  def last_50_purchases
    Connection.send_request(LAST_50_PURCHASES_URL)
  end

  def define_best_item(params)
    if filter_conditions?(params)
      Item.create(class_id:        params[:class_id],
                  instance_id:     params[:instance_id],
                  hash_name:       params[:hash_name],
                  price:           params[:current_price],
                  link:            ITEM_LINK % { class_id:           params[:class_id],
                                                 instance_id:        params[:instance_id], 
                                                 i_market_hash_name: params[:hash_name] },
                  status:          NEW_ITEMS_STATUS)
      puts ITEM_CREATED_TEXT
    else 
      puts COUNT_FOUND_ITEMS_TEXT % { count_item: Item.where(status: NEW_ITEMS_STATUS).size }
    end
  end

  def filter_conditions?(params)
    if params[:current_price].to_f > min_price(params) &&
       params[:current_price].to_f > params[:from_price_input_val].to_i &&
       params[:current_price].to_f < params[:to_price_input_val].to_i &&
       item_not_exists?(params[:class_id], params[:instance_id], params[:hash_name]) &&
       item_profitability?(price_of_buy(params), price_of_sell(params), 1000)
      true
    else
      false
    end
  end

  def item_not_exists?(class_id, instance_id, hash_name)
    Item.exists?(link: ITEM_LINK % { class_id:           class_id,
                                     instance_id:        instance_id, 
                                     i_market_hash_name: hash_name.gsub(' ','+') }) ? false : true
  end

  def item_profitability?(price_of_buy, price_of_sell, limit_of_benefit)
    clean_benefit = price_of_sell - price_of_buy - (price_of_sell / 100 * 10)

    clean_benefit >= limit_of_benefit ? true : false
  end

  def price_of_buy(params)
    best_offer_price(BEST_BUY_OFFER_URL % { class_id:        params[:class_id], 
                                            instance_id:     params[:instance_id], 
                                            your_secret_key: Rails.application.secrets.your_secret_key })
  end

  def price_of_sell(params)
    best_offer_price(BEST_SELL_OFFER_URL % { class_id:        params[:class_id], 
                                             instance_id:     params[:instance_id], 
                                             your_secret_key: Rails.application.secrets.your_secret_key })
  end

  def best_offer_price(url)
    response = Connection.send_request(url)
    response[ITEM_HASH_BEST_OFFER_KEY].to_i
  end
end
