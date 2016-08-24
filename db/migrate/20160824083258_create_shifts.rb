class CreateShifts < ActiveRecord::Migration[5.0]
  def change
    create_table :shifts do |t|
      t.integer :day_of_week, default: 0, null: false
      t.string :start_time, null: false
      t.string :end_time, null: false
      t.integer :sites_reserved, null: false, default: 0
      t.references :room, index: true, foreign_key: true

      t.timestamps
    end
  end
end
