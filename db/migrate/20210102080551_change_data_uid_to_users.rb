class ChangeDataUidToUsers < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :uid, :text
  end
end
