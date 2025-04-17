class FridgesController < ApplicationController
  before_action :set_fridge, only: [:show, :edit, :update, :clear, :add_ingredient]

  def new
    @kitchen = current_user.kitchen
    @fridge = @kitchen.build_fridge
    @categories = Category.includes(:ingredients)
  end

  def create
    @kitchen = current_user.kitchen

    unless @kitchen
      redirect_to new_kitchen_path, alert: "Vous devez d'abord créer une cuisine avant d'ajouter un frigo."
      return
    end

    @fridge = @kitchen.build_fridge

    if @fridge.save
      # Ajout ingrédient custom
      if params[:custom_ingredient].present?
        ingredient = Ingredient.find_or_create_by!(
          name: params[:custom_ingredient].strip.downcase.capitalize,
          custom: true,
          user: current_user,
          category: Category.find_or_create_by(name: 'Other')
        )
        @fridge.ingredients << ingredient unless @fridge.ingredients.include?(ingredient)
      end

      # Ajout des ingrédients sélectionnés
      if params[:fridge]&.[](:ingredient_ids).present?
        ingredient_ids = params[:fridge][:ingredient_ids].reject(&:blank?)
        ingredients = Ingredient.where(id: ingredient_ids)
        @fridge.ingredients << ingredients
      end

      redirect_to my_kitchen_path, notice: 'Frigo créé avec succès !'
    else
      puts "Erreurs de validation : #{@fridge.errors.full_messages}"
      render :new
    end
  end

  def show
    @fridge = current_user.kitchen.fridge
    # @grouped_ingredients = @fridge&.ingredients&.group_by(&:category) || []
  end

  def edit
    @kitchen = current_user.kitchen
    @fridge = @kitchen.fridge
    @categories = Category.all

    @ingredients_by_category = @categories.each_with_object({}) do |category, hash|
      hash[category] = category.ingredients.select do |ingredient|
        !ingredient.custom || (ingredient.custom && ingredient.user_id == current_user.id)
      end
    end
  end

  def update
    unless @fridge
      redirect_to new_fridge_path, alert: "Frigo introuvable."
      return
    end

    # Ajout ingrédients sélectionnés
    if params[:fridge]&.[](:ingredient_ids).present?
      ingredient_ids = params[:fridge][:ingredient_ids].reject(&:blank?)
      ingredients = Ingredient.where(id: ingredient_ids)
      @fridge.ingredients << ingredients.reject { |i| @fridge.ingredients.include?(i) }
    end

    # Ajout ingrédient custom
    if params[:custom_ingredient].present?
      ingredient = Ingredient.find_or_create_by!(
        name: params[:custom_ingredient].strip.downcase.capitalize,
        custom: true,
        user: current_user,
        category: Category.find_or_create_by(name: 'Other')
      )
      @fridge.ingredients << ingredient unless @fridge.ingredients.include?(ingredient)
    end

    redirect_to my_kitchen_path, notice: "Frigo mis à jour avec succès !"
  end

  def add_ingredient
    @ingredient = Ingredient.find(params[:ingredient_id])

    if @fridge.ingredients << @ingredient
      redirect_to my_kitchen_path, notice: 'Ingrédient(s) ajouté avec succès.'
    else
      redirect_to my_kitchen_path, alert: 'Erreur lors de l\'ajout de l\'ingrédient.'
    end
  end

  def clear
    if @fridge
      @fridge.ingredients.clear
      redirect_to my_kitchen_path, notice: 'Frigo vidé avec succès.'
    else
      redirect_to my_kitchen_path, alert: 'Frigo introuvable.'
    end
  end

  private

  def fridge_params
    params.require(:fridge).permit(:name, :capacity, :custom_ingredient, ingredient_ids: [])
  end

  def set_fridge
    @fridge = current_user.kitchen&.fridge
  end
end
