class HomeController < ApplicationController
  def index
    @not_actually_main_items = Item.where(status: Constant::NOT_ACTUALLY_MAIN_ITEMS_STATUS)
    @actually_main_items     = Item.where(status: Constant::ACTUALLY_MAIN_ITEMS_STATUS).order("price")
    @main_items              = Item.where(status: Constant::MAIN_ITEMS_STATUS)
    @new_items               = Item.where(status: Constant::NEW_ITEMS_STATUS)
    @all_main_items          = @main_items + @actually_main_items + @not_actually_main_items
  end

  def inventary
    @sale_items      = Item.where(status: Constant::SALE_ITEMS_STATUS).order("ui_price")
    @cheap_items     = Item.where('ui_price < ?', 30)
    @expensive_items = Item.where('ui_price > ?', 30)
  end

  def button_update_sale_items
    main_object.update_sale_items_in_my_db

    respond_to do |format|
      format.html { redirect_to inventary_url, notice: 'Sale items is updated!' }
    end
  end

  def button_find_new_items
    main_object.find_new_items(params[:from_price], params[:to_price], params[:count_item])

    respond_to do |format|
      format.html { redirect_to home_index_url, notice: 'Items found!' }
    end
  end

  def button_change_status_new_to_main
    main_object.change_status_new_to_main

    respond_to do |format|
      format.html { redirect_to home_index_url, notice: 'Status changed!' }
    end
  end

  def button_re_create_buy_orders
    main_object.re_create_buy_orders

    respond_to do |format|
      format.html { redirect_to home_index_url, notice: 'Purchase orders re-created!' }
    end
  end

  def button_remove_ident_items
    main_object.remove_ident_items

    respond_to do |format|
      format.html { redirect_to home_index_url, notice: 'The identical items are deleted!' }
    end
  end

  def button_update_status
    main_object.update_status

    respond_to do |format|
      format.html { redirect_to home_index_url, notice: 'Status is updated!' }
    end
  end

  def button_update_price_bought_items
    main_object.update_price_bought_items
    main_object.update_sale_items_in_my_db

    respond_to do |format|
      format.html { redirect_to home_index_url, notice: 'Price of bought items is updated!' }
    end
  end

  private

  def main_object
    @main_object ||= Item.new
  end
end
