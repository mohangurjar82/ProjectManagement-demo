class CreateAssignments < ActiveRecord::Migration[6.0]
  def change
    create_table :assignments do |t|
      t.integer :user_id
      t.integer :project_id
      t.integer :assigned_by_id
      t.datetime :assigned_at
      t.string :uuid

      t.timestamps
    end
  end
end
