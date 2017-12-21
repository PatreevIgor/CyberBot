module CreateOrders
  STATUS_ACTUALLY_MAIN_ITEMS = 'main_actually'.freeze
  DELETE_ORDERS_URL          = 'https://market.dota2.net/api/DeleteOrders/?key=%{your_secret_key}'.freeze
  CREATE_ORDER_URL           = 'https://market.dota2.net/api/ProcessOrder/'\
                               '%{class_id}/%{instance_id}/%{price}/?key=%{your_secret_key}'.freeze

  def re_create_buy_orders
    delete_orders
    create_requests_for_actually_main_items
  end

  private

  def delete_orders
    Connection.send_request(DELETE_ORDERS_URL % { your_secret_key: Rails.application.secrets.your_secret_key })
  end

  def create_requests_for_actually_main_items
    Item.where(status: STATUS_ACTUALLY_MAIN_ITEMS).each do |item|
      create_order_item(item.class_id, item.instance_id, order_price(item) + 0001)
    end
  end

  def create_order_item(class_id, instance_id, price)
    Connection.send_request(CREATE_ORDER_URL % { class_id:        class_id,
                                                 instance_id:     instance_id,
                                                 your_secret_key: Rails.application.secrets.your_secret_key })
  end

  def order_price(item)
    best_offer_price(CheckItems::BEST_BUY_OFFER_URL % { class_id:        item.class_id, 
                                                        instance_id:     item.instance_id, 
                                                        your_secret_key: Rails.application.secrets.your_secret_key })
  end
end
