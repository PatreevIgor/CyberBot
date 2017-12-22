module ChangeStatus
  MAIN_ITEMS_STATUS = 'main'.freeze
  NEW_ITEMS_STATUS  = 'new'.freeze

  def change_status_new_to_main
    Item.where(status: NEW_ITEMS_STATUS).each do |item|
      item.status = MAIN_ITEMS_STATUS
      item.save!
    end
  end
end
