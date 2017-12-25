require "rails_helper"

RSpec.describe Item, :type => :model do
  let(:get_orders_log) { {"success"=>true, "log"=>[{"status"=>true, 
                                                    "classid"=>487251205, 
                                                    "instanceid"=>0, 
                                                    "name"=>"Treasure of the Cloven World", 
                                                    "market_hash_name"=>"Treasure of the Cloven World", 
                                                    "color"=>"D2D2D2", 
                                                    "quality"=>"Standard", 
                                                    "rarity"=>"Uncommon", 
                                                    "image"=>"https://cdn.dota2.net/item/Treasure+of+the+Cloven+World/150.png", 
                                                    "price"=>3343, 
                                                    "comment"=>nil, 
                                                    "executed"=>1513773075},

                                                   {"status"=>true, 
                                                    "classid"=>1169458911, 
                                                    "instanceid"=>230145964, 
                                                    "name"=>"Huntling", 
                                                    "market_hash_name"=>"Huntling", 
                                                    "color"=>"D2D2D2", 
                                                    "quality"=>"Standard", 
                                                    "rarity"=>"Immortal", 
                                                    "image"=>"https://cdn.dota2.net/item/Huntling/150.png", 
                                                    "price"=>5600, "comment"=>nil, "executed"=>1513543670}
                                                  ]} }
  let(:var) {  }
end
