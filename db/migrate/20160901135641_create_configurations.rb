class CreateConfigurations < ActiveRecord::Migration[5.0]
  def change
    create_table :configurations do |t|
      t.integer :singleton_guard, default: 0, null: false
      t.boolean :global_lock, default: false, null: false

      t.timestamps
    end
    add_index :configurations, :singleton_guard, unique: true
  end
end
