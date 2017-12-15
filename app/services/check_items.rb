module CheckItems
  STATUS_NEW_ITEMS      = 'new'.freeze
  LAST_50_PURCHASES_URL = 'https://market.dota2.net/history/json/'.freeze

  @@h_test = {}
  def check_50_last_sales(from_price, to_price, coeff_val)
    last_50_purchases.each do |item_hash, empty_val|
      # sleep(0.2)
      define_best_item(class_id:             item_hash['classid'],
                       instance_id:          item_hash['instanceid'],
                       current_price:        item_hash['price'],
                       hash_name:            item_hash['hash_name'],
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
                  coef_cur_state:  coefficient_current_state_of_prices(params),
                  link:            item_link(params[:class_id],
                                             params[:instance_id], 
                                             params[:hash_name]),
                  status:                    STATUS_NEW_ITEMS) unless Item.exists?(:link => item_link(params[:class_id],params[:instance_id],params[:hash_name]))

      puts "Выгодная шмотка. 
            Текушая цена #{params[:current_price].to_f}.
            Мин #{min_price(params)} 
            Cредняя #{middle_price(params)} 
            Макс #{max_price(params)} 
            # Коэф текущего состояния цены: #{coefficient_current_state_of_prices(params)} 
            IDs:#{params[:class_id]}_#{params[:instance_id]}
            Найдено #{Item.where(status: 'new').size} новых шмоток!"
    else 
      puts "Найдено #{Item.where(status: 'new').size} новых шмоток!"
    end
  end

  private

  def filter_conditions?(params)
    if params[:current_price].to_f > min_price(params) &&
       params[:current_price].to_f > params[:from_price_input_val].to_i &&
       params[:current_price].to_f < params[:to_price_input_val].to_i &&
       # coefficient_current_state_of_prices(params) > params[:coeff_input_val].to_i &&
       coefficient_profit(best_offer_price(best_buy_offer_url(params[:class_id], params[:instance_id])),
                          best_offer_price(best_sell_offer_url(params[:class_id], params[:instance_id])),
                          2000) == true
      return true
    else
      return false
    end
  end

  def coefficient_current_state_of_prices(params)
    # binding.pry
    # diff_min_max = max_price(params) - min_price(params)
    # diff_min_cur = params[:current_price].to_f - min_price(params)
    # coefficient = 100 - diff_min_cur*100/diff_min_max
    if params[:current_price].to_f > middle_price(params)
      coefficient = 0
    else
      diff_middle_min = middle_price(params) - min_price(params)
      diff_middle_curr = params[:current_price].to_f - min_price(params)
      coefficient = 100 - diff_middle_curr * 100 / diff_middle_min
    end
    sprintf("%.2f", coefficient).to_f
  end

  def coefficient_profit(price_of_buy, price_of_sell, limit)
    if (price_of_sell - price_of_buy) - (price_of_sell/100*10) > 0 &&
       (price_of_sell - price_of_buy) >= limit
      # puts 'coefficient_profit - true'
      # puts "(price_of_sell - price_of_buy) = #{(price_of_sell - price_of_buy)}"
      return true
    else
      # puts 'coefficient_profit - false'
      return false
    end
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
    # binding.pry
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

  def item_link(i_classid, i_instanceid, i_market_hash_name)
    "https://market.dota2.net/item/#{i_classid}-#{i_instanceid}-#{i_market_hash_name.gsub(' ','+')}/"
  end

  def best_offer_price(url)
    response = Connection.send_request(url)
    response['best_offer'].to_i
  end

  def item_history_url(class_id, instance_id)
    url = "https://market.dota2.net/api/ItemHistory/#{class_id.to_s}_#{instance_id.to_s}/?key="\
          "#{Rails.application.secrets.your_secret_key}"
  end

  def best_sell_offer_url(class_id, instance_id)
    "https://market.dota2.net/api/BestSellOffer/#{class_id}_#{instance_id}/?key="\
    "#{Rails.application.secrets.your_secret_key}"
  end

  def best_buy_offer_url(class_id, instance_id)
    "https://market.dota2.net/api/BestBuyOffer/#{class_id}_#{instance_id}/?key="\
    "#{Rails.application.secrets.your_secret_key}"
  end
end
