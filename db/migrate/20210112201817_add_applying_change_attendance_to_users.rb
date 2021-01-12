class AddApplyingChangeAttendanceToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :applying_change_attendance, :boolean, default: false
  end
end
