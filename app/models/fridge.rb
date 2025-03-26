class Fridge < ApplicationRecord
  has_many :fridge_ingredients, dependent: :destroy
  has_many :ingredients, through: :fridge_ingredients
  belongs_to :kitchen

  accepts_nested_attributes_for :ingredients, allow_destroy: true
end
