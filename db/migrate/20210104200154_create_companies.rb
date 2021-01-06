class CreateCompanies < ActiveRecord::Migration[5.1]
  def change
    create_table :companies do |t|
      t.string :name, null:false
      t.boolean :attendance_flag, default:false

      t.timestamps
    end
  end
end
