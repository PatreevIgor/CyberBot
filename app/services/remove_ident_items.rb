module RemoveIdentItems
  def remove_ident_items
    items = Item.where(status: Constant::MAIN_ITEMS_STATUS) + Item.where(status: Constant::NOT_ACTUALLY_MAIN_ITEMS_STATUS)
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
