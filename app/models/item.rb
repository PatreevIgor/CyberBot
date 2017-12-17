class Item < ApplicationRecord
  include CheckItems
  include Inventary
  include CreateOrders
  include UpdateStatus
  include ChangeStatus
  include RemoveIdentItems

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |item|
        csv << item.attributes.values
      end
    end
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      Item.create! row.to_hash
    end
  end
end
