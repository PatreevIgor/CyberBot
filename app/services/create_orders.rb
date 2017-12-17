module CreateOrders
  STATUS_ACTUALLY_MAIN_ITEMS = 'main_actually'.freeze
  DELETE_OLD_ORDERS_URL      = "https://market.dota2.net/api/DeleteOrders/?key="\
                               "#{Rails.application.secrets.your_secret_key}"

  def re_create_buy_orders
    delete_old_orders
    create_requests_for_actually_main_items
  end

  private

  def delete_old_orders
    Connection.send_request(DELETE_OLD_ORDERS_URL)
  end

  def create_requests_for_actually_main_items
    Item.where(status: STATUS_ACTUALLY_MAIN_ITEMS).each do |item|
      create_order_item(item.class_id, item.instance_id, order_price(item) + 0001)
    end
  end

  def create_order_item(class_id, instance_id, price)
    Connection.send_request("https://market.dota2.net/api/ProcessOrder/#{class_id}/#{instance_id}/#{price}/?key="\
                            "#{Rails.application.secrets.your_secret_key}")
  end

  def order_price(item)
    best_offer_price(best_buy_offer_url(item.class_id, item.instance_id))
  end
end
