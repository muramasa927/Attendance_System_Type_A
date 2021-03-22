class AddMonthToApprovals < ActiveRecord::Migration[5.1]
  def change
    add_column :approvals, :month, :date
  end
end
