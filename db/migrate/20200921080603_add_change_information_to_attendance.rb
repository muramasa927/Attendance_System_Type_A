class AddChangeInformationToAttendance < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :change_information, :boolean, default: 0
  end
end
