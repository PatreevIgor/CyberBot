module ChangeStatus
  def change_status_new_to_main
    Item.where(status: Constant::NEW_ITEMS_STATUS).each do |item|
      item.status = Constant::MAIN_ITEMS_STATUS
      item.save!
    end
  end
end
