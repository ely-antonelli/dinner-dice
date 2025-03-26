class AddUserIdToRecipes < ActiveRecord::Migration[7.1]
  def change
    add_column :recipes, :user_id, :integer
    add_foreign_key :recipes, :users  # Ajoute une contrainte de clé étrangère
    add_index :recipes, :user_id  # Ajoute un index pour optimiser les requêtes
  end
end
