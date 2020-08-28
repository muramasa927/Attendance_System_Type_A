class AddApplicationInformationToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :application_information, :integer
    add_column :attendances, :apply_user_id, :integer
    add_column :attendances, :receive_superior_id, :integer
  end
end
