class AddChangeApprovalToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :change_approval, :boolean
    add_column :users, :approval_information, :interger
  end
end
