class AddAttendanceFlagToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :attendance_flag, :boolean, default: false
  end
end
