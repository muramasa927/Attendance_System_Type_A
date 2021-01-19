class AddLogChangeAttendanceInformationToHistories < ActiveRecord::Migration[5.1]
  def change
    add_column :histories, :log_change_attendance_information, :integer
    add_column :histories, :log_before_started_at, :datetime
    add_column :histories, :log_before_finished_at, :datetime
    add_column :histories, :log_after_started_at, :datetime
    add_column :histories, :log_after_finished_at, :datetime
    add_column :histories, :log_instruction_superior_id, :integer
    add_column :histories, :log_date_of_apploval, :datetime
    add_column :histories, :log_started_at_to_change_attendance, :datetime
    add_column :histories, :log_finished_at_to_change_attendance, :datetime
    add_column :histories, :log_receive_superior_id_to_change_attendance, :integer
  end
end
