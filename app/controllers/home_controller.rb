class HomeController < ApplicationController
  def index
    @items = Item.all
  end

  def get_any_items
    count_items_database = Item.count
    count_items_params =   params[:count_item].to_i
    loop do
      main_object.check_50_last_sales(params[:from_price], params[:to_price], params[:coeff_val])
    break if count_items_database >= count_items_params
    end 
    redirect_to action: 'index'
  end

  private

  def main_object
    @main_object ||= Item.new
  end

  def define_best_item(params)
    main_object.define_best_item(params)
  end
end
