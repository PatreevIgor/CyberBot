namespace :change_fields do
  desc 'Change any items'
  #rake change_fields:replase_space_to_plus
  task :replase_space_to_plus => :environment do
    Item.where(status: Constant::NOT_ACTUALLY_MAIN_ITEMS_STATUS).each do |item|
      item.link = item.link.gsub(' ','+')
      item.save!
    end
  end
end
