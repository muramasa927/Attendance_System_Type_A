class AddNextDayToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :next_day, :boolean
    add_column :attendances, :business_processing_content, :text
  end
end
