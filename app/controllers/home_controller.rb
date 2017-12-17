class HomeController < ApplicationController
  STATUS_NOT_ACTUALLY_MAIN_ITEMS = 'main_not_actually'.freeze
  STATUS_ACTUALLY_MAIN_ITEMS     = 'main_actually'.freeze
  STATUS_NOT_SALE_ITEMS          = 'not sale'.freeze
  STATUS_SALE_ITEMS              = 'sale on'.freeze
  STATUS_MAIN_ITEMS              = 'main'.freeze
  STATUS_NEW_ITEMS               = 'new'.freeze

  def index
    @not_actually_main_items = Item.where(status: STATUS_NOT_ACTUALLY_MAIN_ITEMS)
    @actually_main_items     = Item.where(status: STATUS_ACTUALLY_MAIN_ITEMS)
    @main_items              = Item.where(status: STATUS_MAIN_ITEMS)
    @new_items               = Item.where(status: STATUS_NEW_ITEMS)
    @all_main_items          = @main_items + @actually_main_items + @not_actually_main_items
  end

  def inventary
    @not_sale_items = Item.where(status: STATUS_NOT_SALE_ITEMS)
    @sale_items     = Item.where(status: STATUS_SALE_ITEMS)
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
