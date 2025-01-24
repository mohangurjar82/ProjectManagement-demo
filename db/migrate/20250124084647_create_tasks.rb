class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :description
      t.datetime :start_time
      t.datetime :end_time
      t.integer :duration
      t.integer :project_id
      t.string :uuid
      t.integer :created_by_id
      
      t.timestamps
    end
  end
end
