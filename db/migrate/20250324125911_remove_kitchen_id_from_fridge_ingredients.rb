class RemoveKitchenIdFromFridgeIngredients < ActiveRecord::Migration[7.1]
  def change
    remove_column :fridge_ingredients, :kitchen_id, :integer
  end
end
