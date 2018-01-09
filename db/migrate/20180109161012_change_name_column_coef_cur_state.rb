class ChangeNameColumnCoefCurState < ActiveRecord::Migration[5.1]
  def change
    rename_column :items, :coef_cur_state, :amount_of_profitability
  end
end
