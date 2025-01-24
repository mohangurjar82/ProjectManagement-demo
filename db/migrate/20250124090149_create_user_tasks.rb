class CreateUserTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :user_tasks do |t|
      t.integer :user_id
      t.integer :task_id
      t.integer :assigned_by_id
      t.datetime :assigned_at
      t.string :uuid

      t.timestamps
    end
  end
end
