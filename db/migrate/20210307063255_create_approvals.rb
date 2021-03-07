class CreateApprovals < ActiveRecord::Migration[5.1]
  def change
    create_table :approvals do |t|
      t.boolean :approve, default: false
      t.boolean :apply, default: false
      t.boolean :change, default: false
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
