# Création des utilisateurs avec leurs cuisines et frigos
users = [
  { email: "ely@gmail.com", password: "dinner" }
]

users.each do |user_data|
  user = User.find_or_create_by(email: user_data[:email]) do |u|
    u.password = user_data[:password]
    u.password_confirmation = user_data[:password]
  end

  # Vérifie si la Kitchen existe déjà pour l'utilisateur
  kitchen = Kitchen.find_or_create_by(name: "My kitchen", user: user)

  # Vérifie si le Fridge existe déjà pour cette Kitchen
  Fridge.find_or_create_by!(kitchen: kitchen)
end

# Création des catégories et ingrédients avec `find_or_create_by` pour éviter les doublons
categories = {
"Vegetables" => ["Tomato", "Leek", "Carrot", "Bell pepper", "Zucchini", "Eggplant", "Potato", "Onion", "Garlic", "Spinach", "Lettuce", "Cauliflower", "Broccoli", "Green beans", "Mushrooms", "Cucumber",
  "Celery", "Radish", "Turnip", "Parsnip", "Brussels sprouts", "Cabbage", "Red cabbage", "Kale", "Endive", "Chicory", "Fennel", "Artichoke", "Asparagus", "Beetroot", "Pumpkin", "Butternut squash", "Sweet potato", "Peas", "Corn", "Okra", "Chard", "Scallion", "Shallot", "Watercress", "Rutabaga", "Daikon radish"],

"Dairy" => ["Milk", "Butter", "Fresh cream", "Cheese (Gruyère)", "Cheese (Camembert)", "Cheese (Roquefort)", "Cheese (Mozzarella)", "Cheese (Parmesan)", "Plain yogurt", "Fromage blanc", "Goat milk", "Faisselle", "Ricotta", "Mascarpone",
  "Cheese (Cheddar)", "Cheese (Brie)", "Cheese (Gorgonzola)", "Cheese (Feta)", "Cheese (Emmental)", "Cheese (Blue cheese)", "Cheese (Halloumi)", "Cheese (Cottage cheese)", "Greek yogurt", "Skyr", "Sour cream", "Curd", "Clotted cream", "Quark", "Whey", "Kefir", "Sheep milk"],

"Proteins" => ["Chicken", "Salmon", "Cod", "Tuna", "Sardine", "Shrimp", "Tofu", "Eggs", "Lentils", "Chickpeas", "Red beans", "Sausages", "Ham", "Ground beef",
  "Turkey", "Duck", "Pork", "Beef", "Lamb", "Veal", "Trout", "Haddock", "Mackerel", "Anchovies", "Scallops", "Crab", "Lobster", "Octopus", "Squid", "Seitan", "Tempeh", "Black beans", "White beans", "Peas", "Edamame", "Nuts", "Almonds", "Peanut butter", "Sunflower seeds", "Chia seeds", "Flax seeds"],

"Grains & Starches" => ["Rice", "Pasta", "Bread", "Flour", "Couscous", "Quinoa", "Barley", "Bulgur", "Oats", "Millet", "Corn", "Polenta", "Semolina", "Buckwheat", "Farro", "Rye", "Sorghum", "Amaranth", "Whole wheat", "Brown rice", "Basmati rice", "Jasmine rice", "Wild rice", "Noodles", "Udon", "Soba", "Vermicelli", "Orzo",
    "Gnocchi", "Tortillas", "Crackers"],

"Fruits" => ["Apple", "Banana", "Orange", "Lemon", "Lime", "Grapefruit", "Mandarin", "Pear", "Peach", "Apricot", "Plum", "Cherry", "Strawberry", "Raspberry", "Blackberry", "Blueberry", "Grape", "Watermelon", "Cantaloupe", "Honeydew melon", "Pineapple", "Mango", "Papaya", "Kiwi", "Fig", "Pomegranate", "Coconut",
  "Date", "Persimmon", "Lychee", "Passion fruit", "Dragon fruit", "Guava", "Starfruit", "Cranberry", "Gooseberry", "Mulberry", "Currant", "Avocado"]

"Custom Ingredients" => ["", ""]
}

category_objects = {}

categories.each do |category_name, ingredients|
  category = Category.find_or_create_by(name: category_name)

  ingredients.each do |ingredient_name|
    Ingredient.find_or_create_by(name: ingredient_name, category: category)
  end

  # Vérifier si l'icône est déjà attachée
  unless category.icon.attached?
    file_path = Rails.root.join('app', 'assets', 'images', 'category_icons', "#{category_name.downcase}.png")
    if File.exist?(file_path)
      file = File.open(file_path)
      category.icon.attach(io: file, filename: "#{category_name.downcase}.png", content_type: "image/png")
      file.close
    else
      puts "⚠️ Icon file not found for category: #{category_name}"
    end
  end
end

# Ajout d'ingrédients aux frigos (évite les doublons)
Fridge.all.each do |fridge|
  Ingredient.order("RANDOM()").limit(3).each do |ingredient|
    FridgeIngredient.find_or_create_by(fridge: fridge, ingredient: ingredient)
  end
end


puts "✅ Seed terminée avec succès !"
