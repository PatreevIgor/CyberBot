require "rails_helper"

RSpec.describe Item, :type => :model do
  let(:item) { FactoryBot.create(:item) }
  let(:last_50_purchases) { [{"classid"=>"1925766506",
                               "instanceid"=>"2507977070", 
                               "hash_name"=>"Item1",
                               "price"=>10, 
                               "time"=>"1514112965", 
                               "id"=>"38472070"},

                              {"classid"=>"124470362", 
                               "instanceid"=>"673388756",
                               "hash_name"=>"Item2", 
                               "price"=>45, 
                               "time"=>"1514112947", 
                               "id"=>"38472062"},

                              {"classid"=>"673151410", 
                               "instanceid"=>"0", 
                               "hash_name"=>"Item3", 
                               "price"=>150, 
                               "time"=>"1514112940",
                               "id"=>"38472058"}] }
  let(:last_50_purchases_massive_valid_item) { {"classid"=>"124470362", 
                                               "instanceid"=>"673388756",
                                               "hash_name"=>"Item2", 
                                               "price"=>45, 
                                               "time"=>"1514112947", 
                                               "id"=>"38472062"} }
  let(:last_50_purchases_massive_invalid_item) { {"classid"=>"124470362", 
                                                 "instanceid"=>"673388756",
                                                 "hash_name"=>"Item2", 
                                                 "price"=>5, 
                                                 "time"=>"1514112947", 
                                                 "id"=>"38472062"} }

  context "Servise check_items" do
    it "Check method filter_conditions?" do
      expect().to eq()
    end
  end
end
