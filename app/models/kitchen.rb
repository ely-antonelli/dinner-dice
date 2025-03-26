class Kitchen < ApplicationRecord
  belongs_to :user
  has_one :fridge, dependent: :destroy
  # has_many :fridge_ingredients
  # has_many :ingredients, through: :fridge_ingredients
end
