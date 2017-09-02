module CheckItems
  def check_50_last_sales(from_price = 10, to_price = 50, coeff_val = 80)
    last_50_purchases.each do |item_hash, empty_val|
      sleep(1)
      define_best_item(class_id:      item_hash['classid'],
                       instance_id:   item_hash['instanceid'],
                       secret_key:    Rails.application.secrets.your_secret_key,
                       current_price: item_hash['price'],
                       hash_name:     item_hash['hash_name'],

                       from_price_input_val:    from_price,
                       to_price_input_val:      to_price,
                       coeff_input_val:         coeff_val
                       )
    end
  end

  def last_50_purchases
    Connection.send_request('https://market.dota2.net/history/json/')
  end

  def define_best_item(params)
    if filter_conditions?(params)
      Item.create(class_id:            params[:class_id],
                  instance_id:         params[:instance_id],
                  hash_name:           params[:hash_name],
                  price:               params[:current_price],
                  coefficient_profit:  coefficient_profit(params),
                  link:                "https://market.dota2.net/item/#{params[:class_id]}-#{params[:instance_id]}-#{params[:hash_name].gsub(' ','+')}/")
      puts "Выгодная шмотка. Текушая цена #{params[:current_price].to_f}.
            Мин #{min_price(params)} 
            Макс #{max_price(params)} 
            Коэф выгоды: #{coefficient_profit(params)} 
            IDs:#{params[:class_id]}_#{params[:instance_id]}"
    else 
      puts "Мусор. Текушая цена #{params[:current_price].to_f}. 
            Мин #{min_price(params)} 
            Макс #{max_price(params)} 
            Коэф выгоды: #{coefficient_profit(params)} 
            IDs:#{params[:class_id]}_#{params[:instance_id]}"
    end
  end

  private

  def filter_conditions?(params)
    if params[:current_price].to_f > min_price(params) &&
       params[:current_price].to_f > params[:from_price_input_val].to_i &&
       params[:current_price].to_f < params[:to_price_input_val].to_i &&
       coefficient_profit(params) > params[:coeff_input_val].to_i
      return true
    else
      return false
    end
  end

  def coefficient_profit(params)
    diff_min_max = max_price(params) - min_price(params)
    diff_min_cur = params[:current_price].to_f - min_price(params)
    coefficient = 100 - diff_min_cur*100/diff_min_max

    sprintf("%.2f", coefficient).to_f
  end

  def max_price(params)
    min_max_prices = get_hash_min_and_max_prices(params)

    max_price = min_max_prices["max"].to_f
  end

  def min_price(params)
    min_max_prices = get_hash_min_and_max_prices(params)

    min_price = min_max_prices["min"].to_f
  end

  def get_hash_min_and_max_prices(params)
    url = "https://market.dota2.net/api/ItemHistory/#{params[:class_id].to_s}"\
          "_#{params[:instance_id].to_s}/?key=#{params[:secret_key]}"
    response = Connection.send_request(url)

    create_hash_min_max_prices(response)
  end

  def create_hash_min_max_prices(response)
    min_max_prices = {}
    min_max_prices["min"] = response["min"]/100
    min_max_prices["max"] = response["max"]/100

    min_max_prices
  end
end
