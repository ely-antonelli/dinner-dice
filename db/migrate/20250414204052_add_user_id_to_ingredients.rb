class AddUserIdToIngredients < ActiveRecord::Migration[7.1]
  def change
    add_reference :ingredients, :user, foreign_key: true
  end
end
