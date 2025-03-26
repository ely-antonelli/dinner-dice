class AddUserToKitchens < ActiveRecord::Migration[7.1]
  def change
    add_reference :kitchens, :user, null: false, foreign_key: true
  end
end
