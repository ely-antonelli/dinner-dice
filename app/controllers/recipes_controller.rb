class RecipesController < ApplicationController
  before_action :set_recipe, only: [:edit, :update, :show, :destroy]

  def index
    @recipes = Recipe.where(user_id: current_user.id)
    @ingredients = @recipes.flat_map(&:ingredients).uniq
    @random_recipe = Recipe.order("RANDOM()").first # Sélectionne une recette aléatoire
  end

  def show
    @recipe = Recipe.find(params[:id])
    @ingredients = @recipe.ingredients
  end

  def new
    @recipe = Recipe.new
    @categories = Category.all
    load_ingredients_by_category
  end

  def edit
    @recipe = Recipe.find(params[:id])
    @categories = Category.all
    load_ingredients_by_category
  end

  def update
    if @recipe.update(recipe_params)
      redirect_to @recipe, notice: 'Recipe was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @recipe = Recipe.find(params[:id])
    @recipe.steps.destroy_all
    @recipe.ingredients.clear
    if @recipe.destroy
      redirect_to recipes_path, notice: "Recipe was successfully deleted."
    else
      redirect_to recipes_path, alert: "Failed to delete the recipe."
    end
  end

  def create
    @recipe = current_user.recipes.new(recipe_params)
    if params[:recipe][:ingredient_ids].present?
      ingredient_ids = params[:recipe][:ingredient_ids].reject(&:blank?)
      ingredient_ids.each do |ingredient_id|
        ingredient = Ingredient.find(ingredient_id)
        @recipe.ingredients << ingredient unless @recipe.ingredients.include?(ingredient)
      end
    end
    if @recipe.save
      redirect_to recipes_path, notice: "Recipe successfully created!"
    else
      render :new
    end
  end


  def random
    fridge_ingredient_ids = current_user.fridge_ingredients.pluck(:id)

    if fridge_ingredient_ids.empty?
      render json: { message: "Your fridge is empty! Please, add ingredients to your fridge so we can find a recipe to match!" } and return
    end

    @random_recipe = Recipe.joins(:ingredients)
                         .where(ingredients: { id: fridge_ingredient_ids })
                         .group("recipes.id")
                         .having("COUNT(ingredients.id) = (SELECT COUNT(*) FROM recipe_ingredients WHERE recipe_ingredients.recipe_id = recipes.id)")
                         .order("RANDOM()") # PostgreSQL uniquement (sinon utiliser .sample en Ruby)
                         .first

    if @random_recipe
      render json: {
        id: @random_recipe.id,
        title: @random_recipe.title,
        instructions: @random_recipe.instructions,
        ingredients: @random_recipe.ingredients.map(&:name)
      }
    else
      render json: { message: "No recipes match your ingredients." }
    end
  end



  private

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  def recipe_params
    params.require(:recipe).permit(:title, :instructions, ingredient_ids: [])
  end

  def load_ingredients_by_category
    # On récupère uniquement les ingrédients visibles pour l'utilisateur
    visible_ingredients = Ingredient
      .includes(:category)
      .where(custom: false)
      .or(Ingredient.where(custom: true, user_id: current_user.id))

    @ingredients_by_category = visible_ingredients.group_by(&:category)
  end


end
