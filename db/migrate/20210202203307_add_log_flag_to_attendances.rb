class AddLogFlagToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :log_flag, :boolean, default: false
  end
end
