class AddFieldCoefficientCurrentStateOfPricesToTableItems < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :coef_cur_state, :float
  end
end
