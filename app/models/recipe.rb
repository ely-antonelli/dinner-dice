class Recipe < ApplicationRecord
  has_many :recipe_ingredients
  has_many :ingredients, through: :recipe_ingredients
  has_many :steps, dependent: :destroy
  belongs_to :user

  accepts_nested_attributes_for :ingredients, allow_destroy: true
  accepts_nested_attributes_for :steps, allow_destroy: true

  attr_accessor :ingredient_names

  before_save :assign_ingredients

  def assign_ingredients
    return if ingredient_names.blank?

    self.ingredients = ingredient_names.reject(&:blank?).map do |name|
      Ingredient.find_or_create_by(name: name.strip)
    end
  end

end
