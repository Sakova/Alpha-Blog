class FixColumnName < ActiveRecord::Migration[6.1]
  def change
    rename_column :articles, :update_at, :updated_at
  end
end
