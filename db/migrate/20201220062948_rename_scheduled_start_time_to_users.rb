class RenameScheduledStartTimeToUsers < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :scheduled_start_time, :designated_work_start_time
  end
end
