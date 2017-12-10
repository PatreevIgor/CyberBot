module CreateOrders
  def create_requests_for_main_items
    Item.where(status: 'main').each do |item|
      create_order_item(item.class_id, item.instance_id, order_price(item) + 0001)
    end
  end

  private

  def create_order_item(class_id, instance_id, price)
    Connection.send_request("https://market.dota2.net/api/ProcessOrder/#{class_id}/#{instance_id}/#{price}/?key="\
                            "#{Rails.application.secrets.your_secret_key}")
  end

  def order_price(item)
    best_offer_price(best_buy_offer_url(item.class_id, item.instance_id))
  end
  # Dublicated
  def best_offer_price(url)
    response = Connection.send_request(url)
    response['best_offer'].to_i
  end

  def best_buy_offer_url(class_id, instance_id)
    "https://market.dota2.net/api/BestBuyOffer/#{class_id}_#{instance_id}/?key="\
    "#{Rails.application.secrets.your_secret_key}"
  end
end
