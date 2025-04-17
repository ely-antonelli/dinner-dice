class IngredientsController < ApplicationController
  def index
    @ingredients = Ingredient.all
    render json: @ingredients
  end

  def create
    @ingredient = Ingredient.new(ingredient_params)

    if @ingredient.save
      render json: @ingredient, status: :created
    else
      render json: { errors: @ingredient.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @ingredient = Ingredient.find(params[:id])
    if ingredient.custom?
      redirect_to edit_fridge_path(current_user.kitchen.fridge), alert: "Utilise la suppression personnalisée."
    else
      redirect_to root_path, alert: "Impossible de supprimer un ingrédient standard."
    end
  end

  def destroy_custom
    ingredient = Ingredient.find_by(id: params[:id], custom: true, user: current_user)

    if ingredient.custom? && ingredient.user == current_user
      # On coupe les liens avec les frigos
      ingredient.fridges.clear

      # On coupe les liens avec les recettes
      ingredient.recipes.clear

      # Puis on le détruit
      ingredient.destroy
      redirect_to edit_fridge_path(current_user.kitchen.fridge), notice: "Ingrédient personnalisé supprimé."
    else
      redirect_to edit_fridge_path(current_user.kitchen.fridge), alert: "Action non autorisée."
    end
  end

  private

  def ingredient_params
    params.require(:ingredient).permit(:name, :category_id)
  end
end
