class AddCustomToIngredients < ActiveRecord::Migration[7.1]
  def change
    add_column :ingredients, :custom, :boolean, default: false
    add_column :ingredients, :user_id, :integer, foreign_key: true, optional: true
  end
end
