class AddKitchenToFridges < ActiveRecord::Migration[7.1]
  def change
    add_reference :fridges, :kitchen, null: false, foreign_key: true
  end
end
