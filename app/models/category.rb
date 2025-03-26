class Category < ApplicationRecord
  has_many :ingredients
  has_one_attached :icon
end
