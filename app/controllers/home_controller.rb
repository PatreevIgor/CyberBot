class HomeController < ApplicationController
  def index
    @not_actually_main_items = Item.where(status: Constant::NOT_ACTUALLY_MAIN_ITEMS_STATUS)
    @actually_main_items     = Item.where(status: Constant::ACTUALLY_MAIN_ITEMS_STATUS).order("price")
    @main_items              = Item.where(status: Constant::MAIN_ITEMS_STATUS)
    @new_items               = Item.where(status: Constant::NEW_ITEMS_STATUS)
    @all_main_items          = @main_items + @actually_main_items + @not_actually_main_items
  end

  def inventary
    @not_sale_items = Item.where(status: Constant::NOT_SALE_ITEMS_STATUS)
    @sale_items     = Item.where(status: Constant::SALE_ITEMS_STATUS).order("ui_price")
  end

  def button_update_not_sale_items
    main_object.update_not_sale_items_in_my_db
  end

  def button_update_sale_items
    main_object.update_sale_items_in_my_db
  end

  def button_get_any_items
    main_object.get_any_items(params[:from_price], params[:to_price], params[:coeff_val], params[:count_item])

    redirect_back(fallback_location: root_path)
  end

  def button_change_status_new_to_main
    main_object.change_status_new_to_main

    redirect_back(fallback_location: root_path)
  end

  def button_re_create_buy_orders
    main_object.re_create_buy_orders

    redirect_back(fallback_location: root_path)
  end

  def button_remove_ident_items
    main_object.remove_ident_items

    redirect_back(fallback_location: root_path)
  end

  def button_update_status
    main_object.update_status

    redirect_back(fallback_location: root_path)
  end

  def button_update_price_bought_items
    main_object.update_price_bought_items

    redirect_back(fallback_location: root_path)
  end

  private

  def main_object
    @main_object ||= Item.new
  end
end
