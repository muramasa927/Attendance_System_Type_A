class AddApplyIdToApprovals < ActiveRecord::Migration[5.1]
  def change
    add_column :approvals, :apply_id, :integer
  end
end
