class CreateMyconfigs < ActiveRecord::Migration[5.0]
  def change
    create_table :myconfigs do |t|
      t.integer :singleton_guard, default: 0, null: false
      t.boolean :global_lock, default: false, null: false

      t.timestamps
    end
    add_index :myconfigs, :singleton_guard, unique: true
  end
end
