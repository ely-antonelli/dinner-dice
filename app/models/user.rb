class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one :kitchen, dependent: :destroy
  has_one :fridge, through: :kitchen
  has_many :recipes, dependent: :destroy
  after_create :create_kitchen  # Crée une kitchen automatique pour chaque user

  def fridge_ingredients
    fridge.ingredients
  end

  private

  def create_kitchen
    Kitchen.create(user: self)
  end
end
