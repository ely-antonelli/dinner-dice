class ApplicationController < ActionController::Base
    before_action :authenticate_user!

  def after_sign_in_path_for(resource)
    random_recipe_path # Redirige vers la recette aléatoire après connexion
  end

end
