# $ rake -T | grep displ_items_where_price_is_greater_than_30
# rake displ_items_where_price_is_greater_than_30:displ_inform

namespace :displ_items_where_price_is_greater_than_30 do
  desc 'Display to console infirmation'
  task :displ_inform => :environment do
    Item.where("ui_price > ?", 30).each do |item|
      puts item.i_market_hash_name + ', price = ' + item.ui_price.to_s
    end
  end
end
