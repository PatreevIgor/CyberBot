class HomeController < ApplicationController
  NOT_ACTUALLY_MAIN_ITEMS_STATUS = 'main_not_actually'.freeze
  ACTUALLY_MAIN_ITEMS_STATUS     = 'main_actually'.freeze
  NOT_SALE_ITEMS_STATUS          = 'not sale'.freeze
  SALE_ITEMS_STATUS              = 'sale on'.freeze
  MAIN_ITEMS_STATUS              = 'main'.freeze
  NEW_ITEMS_STATUS               = 'new'.freeze

  def index
    @not_actually_main_items = Item.where(status: NOT_ACTUALLY_MAIN_ITEMS_STATUS)
    @actually_main_items     = Item.where(status: ACTUALLY_MAIN_ITEMS_STATUS)
    @main_items              = Item.where(status: MAIN_ITEMS_STATUS)
    @new_items               = Item.where(status: NEW_ITEMS_STATUS)
    @all_main_items          = @main_items + @actually_main_items + @not_actually_main_items
  end

  def inventary
    @not_sale_items = Item.where(status: NOT_SALE_ITEMS_STATUS)
    @sale_items     = Item.where(status: SALE_ITEMS_STATUS)
  end

  def button_update_not_sale_items
    main_object.update_not_sale_items
  end

  def button_update_sale_items
    main_object.update_sale_items
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

  private

  def main_object
    @main_object ||= Item.new
  end
end
