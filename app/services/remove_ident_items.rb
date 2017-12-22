module RemoveIdentItems
  STATUS_MAIN_ITEMS = 'main'.freeze
  STATUS_NOT_ACTUALLY_MAIN_ITEMS = 'main_not_actually'.freeze

  def remove_ident_items
    items = Item.where(status:STATUS_MAIN_ITEMS) + Item.where(status:STATUS_NOT_ACTUALLY_MAIN_ITEMS)
    empty_massive = []
    items.each do |item|
      if empty_massive.include?(item.link)
        item.destroy
      else
        empty_massive << item.link
      end
    end
  end
end

# module RemoveIdentItems
#   extend ActiveSupport::Concern
#   STATUS_MAIN_ITEMS = 'main'.freeze
#   STATUS_NOT_ACTUALLY_MAIN_ITEMS = 'main_not_actually'.freeze
#   included do
#     scope :main_and_not_actually_main_items, -> { where(status:STATUS_MAIN_ITEMS).where(status:STATUS_NOT_ACTUALLY_MAIN_ITEMS) }
#   end

#   def remove_ident_items
#     items = Item.main_and_not_actually_main_items
#     empty_massive = []
#     items.each do |item|
#       if empty_massive.include?(item.link)
#         item.destroy
#       else
#         empty_massive << item.link
#       end
#     end
#   end
# end

