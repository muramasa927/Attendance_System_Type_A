class ChengeDefaultSuperiorToUsers < ActiveRecord::Migration[5.1]
  def change
    change_column_default :users, :superior, from: true, to: false
  end

end
