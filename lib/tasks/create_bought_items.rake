namespace :create_bought_items do
  desc 'Create biught items'
  #rake create_bought_items:create_items
  task :create_items => :environment do
  
  def bught_items
    Connection.send_request(Constant::GET_ORDERS_LOG_URL % { your_secret_key: Rails.application.secrets.your_secret_key })
  end

    bught_items.each do |success_or_log, items|
      if success_or_log == 'log'
        items.each do |bought_items|

          exist_items_in_db = Item.where(link: Constant::ITEM_LINK_URL % { 
                                           class_id:           bought_items['classid'],
                                           instance_id:        bought_items['instanceid'], 
                                           i_market_hash_name: bought_items['name'].gsub(' ','+') })
          if exist_items_in_db != true 
            Item.create(class_id:           bought_items['classid'],
                        instance_id:        bought_items['instanceid'],
                        i_market_hash_name: bought_items['name'],
                        price_of_buy:       bought_items['price'],
                        link:               Constant::ITEM_LINK_URL % { 
                                              class_id:           bought_items['classid'],
                                              instance_id:        bought_items['instanceid'], 
                                              i_market_hash_name: bought_items['name'].gsub(' ','+') },
                        image: bought_items['image'],
                        status:    Constant::MAIN_ITEMS_STATUS)
          end
        end
      end
    end
  end
end
