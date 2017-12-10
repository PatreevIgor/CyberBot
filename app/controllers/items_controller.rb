class ItemsController < ApplicationController

  def show
    @item = Item.find(params[:id])
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
