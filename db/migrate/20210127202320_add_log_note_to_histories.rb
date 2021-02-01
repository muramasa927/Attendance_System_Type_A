class AddLogNoteToHistories < ActiveRecord::Migration[5.1]
  def change
    add_column :histories, :log_note, :string
  end
end
