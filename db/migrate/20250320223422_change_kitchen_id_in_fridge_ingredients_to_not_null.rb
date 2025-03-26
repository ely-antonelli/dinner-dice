class ChangeKitchenIdInFridgeIngredientsToNotNull < ActiveRecord::Migration[7.1]
  def change
    change_column_null :fridge_ingredients, :kitchen_id, false
  end
end
