module UpdateStatus
  def update_status
    all_main_items = Item.where(status:Constant::MAIN_ITEMS_STATUS) +
                     Item.where(status:Constant::ACTUALLY_MAIN_ITEMS_STATUS) +
                     Item.where(status:Constant::NOT_ACTUALLY_MAIN_ITEMS_STATUS)
    all_main_items.each do |item|
      if coefficient_current_state_of_prices(params_for_coeff_curr_st_of_pr(item)) > 1 &&
         item_profitability?(best_offer_price(Constant::BEST_BUY_OFFER_URL % { 
                                                class_id:        item.class_id, 
                                                instance_id:     item.instance_id,
                                                your_secret_key: Rails.application.secrets.your_secret_key}),
                             best_offer_price(Constant::BEST_SELL_OFFER_URL % { 
                                                class_id:        item.class_id, 
                                                instance_id:     item.instance_id,
                                                your_secret_key: Rails.application.secrets.your_secret_key}),
                             1000) # 1000 = 10 RUB
        item.status                  = Constant::ACTUALLY_MAIN_ITEMS_STATUS
        item.price                   = current_price(item.class_id, item.instance_id)
        # item.amount_of_profitability = amount_of_profitability(best_offer_price(Constant::BEST_BUY_OFFER_URL % { 
        #                                                          class_id:        item.class_id, 
        #                                                          instance_id:     item.instance_id,
        #                                                          your_secret_key: Rails.application.secrets.your_secret_key}),
        #                                                        best_offer_price(Constant::BEST_SELL_OFFER_URL % { 
        #                                                          class_id:        item.class_id, 
        #                                                          instance_id:     item.instance_id,
        #                                                          your_secret_key: Rails.application.secrets.your_secret_key}))
        item.save!
      else
        if item.status == Constant::ACTUALLY_MAIN_ITEMS_STATUS or item.status == Constant::MAIN_ITEMS_STATUS
          item.status = Constant::NOT_ACTUALLY_MAIN_ITEMS_STATUS
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
      diff_middle_min  = middle_price(params) - min_price(params)
      diff_middle_curr = params[:current_price].to_f - min_price(params)
      coefficient      = 100 - diff_middle_curr * 100 / diff_middle_min
    end
    sprintf("%.2f", coefficient).to_f
  end

  def item_profitability?(price_of_buy, price_of_sell, limit_of_benefit)
    clean_benefit = price_of_sell - price_of_buy - (price_of_sell / 100 * 10)

    clean_benefit >= limit_of_benefit ? true : false
  end

  def amount_of_profitability(price_of_buy, price_of_sell)
    clean_benefit = price_of_sell - price_of_buy - (price_of_sell / 100 * 10)
  end

  def params_for_coeff_curr_st_of_pr(item)
    {:class_id      => item.class_id,
     :instance_id   => item.instance_id,
     :current_price => current_price(item.class_id, item.instance_id),
     :hash_name     => item.hash_name}
  end

  def current_price(class_id, instance_id)
    item_informations(class_id, instance_id)[Constant::ITEM_INFO_HASH_MIN_PRICE_KEY].to_f / 100
  end

  def item_informations(class_id, instance_id)
    Connection.send_request(Constant::ITEM_INFORMATION_URL % {
                              class_id:        class_id, 
                              instance_id:     instance_id, 
                              your_secret_key: Rails.application.secrets.your_secret_key })
  end

  def middle_price(params)
    min_middle_max_prices = get_hash_min_middle_max_prices(params)

    middle_price = min_middle_max_prices[Constant::HASH_AVERAGE_KEY].to_f
  end

  def max_price(params)
    min_middle_max_prices = get_hash_min_middle_max_prices(params)

    max_price = min_middle_max_prices[Constant::HASH_MAX_KEY].to_f
  end

  def min_price(params)
    min_middle_max_prices = get_hash_min_middle_max_prices(params)

    min_price = min_middle_max_prices[Constant::HASH_MIN_KEY].to_f
  end

  def get_hash_min_middle_max_prices(params)
    url = Constant::ITEM_HISTORY_URL % { class_id:        params[:class_id].to_s,
                                         instance_id:     params[:instance_id].to_s,
                                         your_secret_key: Rails.application.secrets.your_secret_key}
    response = Connection.send_request(url)

    create_hash_min_middle_max_prices(response)
  end

  def create_hash_min_middle_max_prices(response)
    min_middle_max_prices = {}

    response[Constant::HASH_MIN_KEY] ?
    (min_middle_max_prices[Constant::HASH_MIN_KEY] = response[Constant::HASH_MIN_KEY]/100) :
    (min_middle_max_prices[Constant::HASH_MIN_KEY] = 100/100)

    response[Constant::HASH_MAX_KEY] ?
    (min_middle_max_prices[Constant::HASH_MAX_KEY] = response[Constant::HASH_MAX_KEY]/100) :
    (min_middle_max_prices[Constant::HASH_MAX_KEY] = 200/100)

    response[Constant::HASH_AVERAGE_KEY] ?
    (min_middle_max_prices[Constant::HASH_AVERAGE_KEY] = response[Constant::HASH_AVERAGE_KEY]/100) :
    (min_middle_max_prices[Constant::HASH_MAX_KEY]     = 150/100)

    min_middle_max_prices
  end
end
