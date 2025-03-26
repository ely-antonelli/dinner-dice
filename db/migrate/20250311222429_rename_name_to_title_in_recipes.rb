class RenameNameToTitleInRecipes < ActiveRecord::Migration[7.1]
  def change
    rename_column :recipes, :name, :title
  end
end
