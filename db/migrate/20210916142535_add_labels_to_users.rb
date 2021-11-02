class AddLabelsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :crap_label, :string
    add_column :users, :trap_label, :string
  end
end
