class ChangeNameTypeField < ActiveRecord::Migration[5.1]
  def change
    rename_column :items, :type, :type_new
  end
end
