class ChangeTypeFieldsTableItems < ActiveRecord::Migration[5.1]
  def change
    change_column :items, :ui_id, :string

  end
end
