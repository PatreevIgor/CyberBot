require "rails_helper"

RSpec.describe Item, :type => :model do
  let(:item_info) { 
                    {"classid"=>"487251205", 
                     "instanceid"=>"0", 
                     "our_market_instanceid"=>nil, 
                     "market_name"=>"Treasure of the Cloven World", 
                     "name"=>"Treasure of the Cloven World", 
                     "market_hash_name"=>"Treasure of the Cloven World", 
                     "rarity"=>"Uncommon", 
                     "quality"=>"Standard", 
                     "type"=>nil, 
                     "mtype"=>nil, 
                     "slot"=>"Н/Д", 
                     "description"=>[{"type"=>"html", "value"=>"В этой сокровищнице содержится 2 предмета из следующего списка:"}, 
                                     {"type"=>"html", "value"=>"Red Guard", "color"=>"4b69ff"}, 
                                     {"type"=>"html", "value"=>"Horn of Luminous Crystal", "color"=>"4b69ff"}, 
                                     {"type"=>"html", "value"=>"Furious Rune", "color"=>"4b69ff"}, 
                                     {"type"=>"html", "value"=>"Might of the Old World", "color"=>"4b69ff"}, 
                                     {"type"=>"html", "value"=>"Bloodrage Axe", "color"=>"4b69ff"}, 
                                     {"type"=>"html", "value"=>"Diabolical Appendages", "color"=>"4b69ff"}, 
                                     {"type"=>"html", "value"=>"Infernal Shredder", "color"=>"4b69ff"}, 
                                     {"type"=>"html", "value"=>"Relic Sword", "color"=>"8847ff"}, 
                                     {"type"=>"html", "value"=>" "}, 
                                     {"type"=>"html", "value"=>"Также есть шанс, что внутри находится дополнительный предмет:"}, 
                                     {"type"=>"html", "value"=>"Shroomling", "color"=>"8847ff"}, 
                                     {"type"=>"html", "value"=>"Monty", "color"=>"8847ff"}, 
                                     {"type"=>"html", "value"=>"Чтобы открыть эту сокровищницу, не нужно ни печати, ни ключа: она уже открыта. Эта сокровищница содержит отдельные предметы."}], 
                     "tags"=>[{"internal_name"=>"unique", "name"=>"Standard", "category"=>"Quality", "color"=>"D2D2D2", "category_name"=>"Качество"}, 
                              {"internal_name"=>"Rarity_Uncommon", "name"=>"Uncommon", "category"=>"Rarity", "color"=>"5e98d9", "category_name"=>"Редкость"}, 
                              {"internal_name"=>"treasure_chest", "name"=>"Сокровищница", "category"=>"Type", "category_name"=>"Тип"}, 
                              {"internal_name"=>"none", "name"=>"Н/Д", "category"=>"Slot", "category_name"=>"Ячейка"}, 
                              {"internal_name"=>"DOTA_OtherType", "name"=>"Другие", "category"=>"Hero", "category_name"=>"Герой"}], 
                      "hash"=>"3d2e5d3be081dc7cd989d15fa3f7b1e1", 
                      "min_price"=>"9100", 
                      "offers"=>[{"price"=>"9100", "count"=>"1", "my_count"=>"0"}, 
                                 {"price"=>"19800", "count"=>"1", "my_count"=>"0"}, 
                                 {"price"=>"39680", "count"=>"1", "my_count"=>"0"}], 
                      "buy_offers"=>[{"o_price"=>"2510", "c"=>"1", "my_count"=>"0"}, 
                                     {"o_price"=>"2509", "c"=>"1", "my_count"=>"0"}, 
                                     {"o_price"=>"2508", "c"=>"1", "my_count"=>"0"}, 
                                     {"o_price"=>"2500", "c"=>"1", "my_count"=>"0"}, 
                                     {"o_price"=>"100", "c"=>"7", "my_count"=>"0"}, 
                                     {"o_price"=>"75", "c"=>"1", "my_count"=>"0"}]}
   }

  let(:var) {  }
end
