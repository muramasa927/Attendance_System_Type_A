class AddApplyingOvertimeToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :applying_overtime, :boolean, default: false
  end
end
