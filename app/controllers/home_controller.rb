class HomeController < ApplicationController

  #actions for pages
  def index
    @new_items = Item.where(status: 'new')

    @main_items = Item.where(status: 'main')
    @actually_main_items = Item.where(status: 'main_actually')
    @not_actually_main_items = Item.where(status: 'main_not_actually')

    @all_main_items = @main_items + @actually_main_items + @not_actually_main_items
  end

  def inventary
    @not_sale_items = Item.where(status: 'not sale')
    @sale_items     = Item.where(status: 'sale on')
  end

# actions for buttons
  def action_update_not_sale_items
    main_object.update_not_sale_items
  end

  def action_update_sale_items
    main_object.update_sale_items
  end

  def get_any_items
    count_new_items = Item.where(status: 'new').size.to_i
    count_items_params =   params[:count_item].to_i
    loop do
      main_object.check_50_last_sales(params[:from_price], params[:to_price], params[:coeff_val])
    break if count_new_items >= count_items_params
    end 
    @new_items = Item.where(status: 'new')
    @main_items = Item.where(status: 'main')
    redirect_back(fallback_location: root_path)
  end

  def action_change_status_new_to_main
    @new_items = Item.where(status: 'new')
    @main_items = Item.where(status: 'main')

    Item.where(status: 'new').each do |item|
      item.status = 'main'
      item.save!
    end
    redirect_back(fallback_location: root_path)
  end

  def action_create_queries_automatically_buy_item
    @new_items = Item.where(status: 'new')
    @main_items = Item.where(status: 'main')
    main_object.delete_old_orders
    main_object.create_requests_for_actually_main_items
  end

  def action_remove_ident_items
    @new_items = Item.where(status: 'new')
    @main_items = Item.where(status: 'main')
    empty_massive = []
    @main_items.each do |item|
      if empty_massive.include?(item.link)
        item.destroy
      else
        empty_massive << item.link
      end
    end
    empty_massive = []
    redirect_back(fallback_location: root_path)
  end

  def action_update_status
    main_object.check_actually_status

    redirect_back(fallback_location: root_path)
  end

  private

  def main_object
    @main_object ||= Item.new
  end

  def define_best_item(params)
    main_object.define_best_item(params)
  end
end
