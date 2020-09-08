class AddFinishOvertimeToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :finish_overtime, :datetime
  end
end
