class DeleteTypeFromOffspring < ActiveRecord::Migration[5.0]
  def change
    remove_column :offsprings, :type, :string
  end
end
