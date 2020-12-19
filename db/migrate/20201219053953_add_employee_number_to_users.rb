                   class AddEmployeeNumberToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :employee_number, :string
    add_column :users, :uid, :interger
    add_column :users, :designated_work_start_time, :string
    add_column :users, :designated_work_end_time, :string
  end
end
