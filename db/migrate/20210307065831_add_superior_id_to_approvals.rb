class AddSuperiorIdToApprovals < ActiveRecord::Migration[5.1]
  def change
    add_column :approvals, :superior_id, :integer
    add_column :approvals, :information, :integer
    add_column :approvals, :log_superior_id, :integer
    add_column :approvals, :log_information, :integer
  end
end
