class AddApplovalMonthToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :apploval_month, :datetime, default: nil
  end
end
