class Item < ApplicationRecord
  include CheckItems
  include Inventary
  include CreateOrders
end
