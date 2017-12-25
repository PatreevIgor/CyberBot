namespace :change_fields do
  desc 'Change any items'
  #rake change_fields:replase_space_to_plus
  task :replase_space_to_plus => :environment do
    Item.where(status: Constant::NOT_ACTUALLY_MAIN_ITEMS_STATUS).each do |item|
      item.link = item.link.gsub(' ','+')
      item.save!
    end
  end

  #rake change_fields:replase_status_main_to_not_actually
  task :replase_status_main_to_not_actually => :environment do
    Item.where(status: Constant::MAIN_ITEMS_STATUS).each do |item|
      item.status = Constant::NOT_ACTUALLY_MAIN_ITEMS_STATUS
      item.save!
    end
  end
end
