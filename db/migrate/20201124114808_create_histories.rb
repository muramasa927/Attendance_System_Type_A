class CreateHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :histories do |t|
      t.integer :log_application_information
      t.datetime :log_finish_overtime
      t.boolean :log_next_day
      t.text :log_business_processing_content
      t.integer :log_receive_superior_id
      t.integer :log_apply_user_id
      t.references :attendance, foreign_key: true

      t.timestamps
    end
  end
end
