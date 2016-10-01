class CreateOffsprings < ActiveRecord::Migration[5.0]
  def change
    create_table :offsprings do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :type

      t.timestamps
    end
  end
end
