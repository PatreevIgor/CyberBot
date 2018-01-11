class ItemsController < ApplicationController
  require 'csv'

  def index
    @items               = Item.all
    @actually_main_items = Item.where(status: Constant::ACTUALLY_MAIN_ITEMS_STATUS).order("price")

    respond_to do |format|
      format.html
      format.csv { send_data @actually_main_items.to_csv }
      format.xls 
    end
  end

  def show
    @item = Item.find(params[:id])
  end

  def import
    Item.import(params[:file])

    redirect_back(fallback_location: root_path)
  end

  def destroy
    @item = Item.find(params[:id])
    @item.destroy

    respond_to do |format|
      format.html { redirect_to home_index_url, notice: 'Item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
end
