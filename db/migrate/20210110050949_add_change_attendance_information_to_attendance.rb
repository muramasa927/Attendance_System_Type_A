class AddChangeAttendanceInformationToAttendance < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :change_attendance_information, :integer, default: 0
    add_column :attendances, :receive_superior_id_to_change_attendance, :integer
    add_column :attendances, :apply_user_id_to_change_attendance, :integer
  end
end
