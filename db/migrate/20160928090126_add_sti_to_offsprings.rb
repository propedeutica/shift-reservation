class AddStiToOffsprings < ActiveRecord::Migration[5.0]
  def change
    add_column :offsprings, :grade, :intger
    add_column :offsprings, :age, :integer
  end
end
