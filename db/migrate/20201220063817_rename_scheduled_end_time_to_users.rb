class RenameScheduledEndTimeToUsers < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :scheduled_end_time, :designated_work_end_time
  end
end
