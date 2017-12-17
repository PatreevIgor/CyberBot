module RemoveIdentItems
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
