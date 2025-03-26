class KitchensController < ApplicationController
  before_action :authenticate_user!

  def show
    @kitchen = current_user.kitchen  # Récupère la cuisine de l'utilisateur connecté
    @fridge = current_user.kitchen.fridge  # Récupère le frigo de la cuisine de l'utilisateur
  
    if @kitchen.nil?
      redirect_to new_kitchen_path, alert: "Vous devez créer un frigo (kitchen) avant de pouvoir y ajouter des ingrédients."
      return
    end

    # Récupérer les ingrédients et les regrouper par catégorie
    @ingredients = @kitchen.fridge&.ingredients || []
  end
end
