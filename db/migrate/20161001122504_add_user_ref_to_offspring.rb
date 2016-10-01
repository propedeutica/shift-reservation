class AddUserRefToOffspring < ActiveRecord::Migration[5.0]
  def change
    add_reference :offsprings, :user, foreign_key: true
  end
end
