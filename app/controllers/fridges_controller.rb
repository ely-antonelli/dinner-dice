class FridgesController < ApplicationController

  def new
    @kitchen = current_user.kitchen
    @fridge = @kitchen.build_fridge

    @categories = Category.includes(:ingredients) # Charge les ingrédients en même temps
  end

  def show
    @fridge = current_user.kitchen.fridge
    # @grouped_ingredients = @fridge&.ingredients&.group_by(&:category) || []
  end

  def edit
    @kitchen = current_user.kitchen
    @fridge = @kitchen.fridge
    @categories = Category.includes(:ingredients).all
  end

  def create
    @kitchen = current_user.kitchen
    puts "Kitchen trouvée ? #{@kitchen.present?}"

    if @kitchen.nil?
      redirect_to new_kitchen_path, alert: "Vous devez d'abord créer une cuisine avant d'ajouter un frigo."
      return
    end

    @fridge = @kitchen.build_fridge
    puts "Fridge valide ? #{@fridge.valid?}"

      if @fridge.save
        # Vérifier si des ingrédients ont été sélectionnés et les associer
        if params[:fridge].present? && params[:fridge][:ingredient_ids].present?
          ingredient_ids = params[:fridge][:ingredient_ids].reject(&:blank?)  # Évite les valeurs vides
          ingredients = Ingredient.where(id: ingredient_ids)
          @fridge.ingredients << ingredients
        end
        redirect_to my_kitchen_path, notice: "Frigo créé avec succès !"

      else
      render :new
      puts "Erreurs de validation : #{@fridge.errors.full_messages}"
      end
  end

  def add_ingredient
    @fridge = current_user.kitchen.fridge # Assure-toi de récupérer le frigo de la cuisine du user
    @ingredient = Ingredient.find(params[:ingredient_id])

    if @fridge.ingredients << @ingredient
      redirect_to my_kitchen_path, notice: 'Ingrédient(s) ajouté avec succès.'
    else
      redirect_to my_kitchen_path, alert: 'Erreur lors de l\'ajout de l\'ingrédient.'
    end
  end

  def update
    @fridge = current_user.kitchen&.fridge
    unless @fridge
      redirect_to new_fridge_path, alert: "Frigo introuvable."
      return
    end

    @ingredient = Ingredient.find_by(id: params[:ingredient_id])
    unless @ingredient
      redirect_to fridge_path(@fridge), alert: "Ingrédient introuvable."
      return
    end

    unless @fridge.ingredients.include?(@ingredient)
      @fridge.ingredients << @ingredient
    end

    redirect_to fridge_path(@fridge), notice: "Ingrédient ajouté avec succès !"
  end


  private

    def fridge_params
      params.require(:fridge).permit(:name, :capacity, ingredient_ids: [])
    end

    def set_fridge
      @fridge = Fridge.find_by(id: params[:id])
      redirect_to kitchen_path, alert: "Fridge not found" if @fridge.nil?
    end

end
