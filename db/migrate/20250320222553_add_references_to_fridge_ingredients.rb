class AddReferencesToFridgeIngredients < ActiveRecord::Migration[7.1]
  def change
    add_reference :fridge_ingredients, :kitchen, null: false, foreign_key: true
  end
end
