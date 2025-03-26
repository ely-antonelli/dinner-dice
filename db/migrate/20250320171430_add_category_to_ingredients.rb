class AddCategoryToIngredients < ActiveRecord::Migration[7.1]
  def change
    add_reference :ingredients, :category, foreign_key: true
  end
end
