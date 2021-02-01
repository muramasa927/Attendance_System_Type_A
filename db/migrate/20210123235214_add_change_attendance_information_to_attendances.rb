class AddChangeAttendanceInformationToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :change_information_to_attendance, :boolean
  end
end
