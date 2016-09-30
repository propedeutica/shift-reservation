class AddStiToOffsprings < ActiveRecord::Migration[5.0]
  def change
    add_column :offsprings, :grade, :integer
    add_column :offsprings, :age, :integer
  end
end
