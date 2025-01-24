class CreateProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :projects do |t|
      t.string :name
      t.date :start_date
      t.integer :duration_day
      t.string :duration_timeframe
      t.string :uuid

      t.timestamps
    end
  end
end
