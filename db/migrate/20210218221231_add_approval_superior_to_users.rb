class AddApprovalSuperiorToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :approval_superior, :integer, default: nil
  end
end
