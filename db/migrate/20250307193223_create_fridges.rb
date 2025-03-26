class CreateFridges < ActiveRecord::Migration[7.1]
  def change
    create_table :fridges do |t|
      t.integer :user_id

      t.timestamps
    end
  end
end
