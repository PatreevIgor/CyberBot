module ChangeStatus
  STATUS_MAIN_ITEMS = 'main'.freeze
  STATUS_NEW_ITEMS  = 'new'.freeze

  def change_status_new_to_main
    Item.where(status: STATUS_NEW_ITEMS).each do |item|
      item.status = STATUS_MAIN_ITEMS
      item.save!
    end
  end
end
