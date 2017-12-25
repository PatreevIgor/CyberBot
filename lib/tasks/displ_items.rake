namespace :displ_items do
  desc 'Display any items'
  #rake displ_items:items_greater_than_30
  task :items_greater_than_30 => :environment do
    Item.where("ui_price > ?", 30).each do |item|
      puts item.i_market_hash_name + ', price = ' + item.ui_price.to_s
    end
  end
  #rake displ_items:item_links_by_link
  task :item_links_by_link => :environment do
    sort_by_link_items = Item.where(status: Constant::NOT_ACTUALLY_MAIN_ITEMS_STATUS).order('link')
    sort_by_link_items.each do |item|
      puts item.link
    end
  end
end
