class HomeController < ApplicationController
  def index
    @recipes = Recipe.order("RANDOM()").first
  end
end
