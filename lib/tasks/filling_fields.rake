# $ rake -T | grep filling_fields
# rake filling_fields:fill_all_29_99  # Fill all fields price_of_buy value - 29.99 rub

namespace :filling_fields do
  desc 'Fill fields price_of_buy value - 29.99 rub'
  task :fill_all_29_99 => :environment do
    Item.where("price_of_buy < ?", 30).each do |item|
      item.price_of_buy = 29.99
      item.save
    end
  end
end
