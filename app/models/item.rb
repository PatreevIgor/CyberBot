class Item < ApplicationRecord
  include CheckItems
  include Inventary
  include CreateOrders

  def check_actually_status
    all_main_items = Item.where(status:'main') + Item.where(status:'main_actually') + Item.where(status:'main_not_actually')
    all_main_items.each do |item|
      if coefficient_profit(best_offer_price(best_buy_offer_url(item.class_id,item.instance_id)),
                            best_offer_price(best_sell_offer_url(item.class_id,item.instance_id)),
                            2000) == true
        item.status = 'main_actually'
        item.save!
      else
        item.status = 'main_not_actually'
        item.save!
      end
    end
  end

  private 

  # Dublicated
  def coefficient_profit(price_of_buy, price_of_sell, limit)
    if (price_of_sell - price_of_buy) - (price_of_sell/100*10) > 0 &&
       (price_of_sell - price_of_buy) >= limit
      return true
    else
      return false
    end
  end

  def best_sell_offer_url(class_id, instance_id)
    "https://market.dota2.net/api/BestSellOffer/#{class_id}_#{instance_id}/?key="\
    "#{Rails.application.secrets.your_secret_key}"
  end

  def best_buy_offer_url(class_id, instance_id)
    "https://market.dota2.net/api/BestBuyOffer/#{class_id}_#{instance_id}/?key="\
    "#{Rails.application.secrets.your_secret_key}"
  end

  def best_offer_price(url)
    response = Connection.send_request(url)
    response['best_offer'].to_i
  end
end
