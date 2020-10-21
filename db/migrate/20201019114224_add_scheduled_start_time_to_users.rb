class AddScheduledStartTimeToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :scheduled_start_time, :datetime
    add_column :users, :scheduled_end_time, :datetime
  end
end
