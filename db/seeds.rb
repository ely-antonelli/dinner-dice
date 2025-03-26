# Suppression des données existantes dans le bon ordre pour éviter les erreurs de clé étrangère
FridgeIngredient.destroy_all
Ingredient.destroy_all
Fridge.destroy_all
Kitchen.destroy_all
Category.destroy_all
User.destroy_all

# Création des utilisateurs avec leurs cuisines et frigos
users = [
  { email: "ely@gmail.com", password: "dinner" }
]

users.each do |user_data|
  user = User.create!(
    email: user_data[:email],
    password: user_data[:password],
    password_confirmation: user_data[:password]
  )

  # Créer une Kitchen associée à ce User
  kitchen = Kitchen.create!(name: "My kitchen", user: user)

  # Créer un Fridge lié à cette Kitchen
  Fridge.create!(kitchen: kitchen)
end

# Création des catégories et ingrédients avec `find_or_create_by` pour éviter les doublons
categories = {
"Vegetables" => ["Tomato", "Leek", "Carrot", "Bell pepper", "Zucchini", "Eggplant", "Potato", "Onion", "Garlic", "Spinach", "Lettuce", "Cauliflower", "Broccoli", "Green beans", "Mushrooms", "Cucumber",
  "Celery", "Radish", "Turnip", "Parsnip", "Brussels sprouts", "Cabbage", "Red cabbage", "Kale", "Endive", "Chicory", "Fennel", "Artichoke", "Asparagus", "Beetroot", "Pumpkin", "Butternut squash", "Sweet potato", "Peas", "Corn", "Okra", "Chard", "Scallion", "Shallot", "Watercress", "Rutabaga", "Daikon radish"],

"Dairy" => ["Milk", "Butter", "Fresh cream", "Cheese (Gruyère)", "Cheese (Camembert)", "Cheese (Roquefort)", "Cheese (Mozzarella)", "Cheese (Parmesan)", "Plain yogurt", "Fromage blanc", "Goat milk", "Faisselle", "Ricotta", "Mascarpone",
  "Cheese (Cheddar)", "Cheese (Brie)", "Cheese (Gorgonzola)", "Cheese (Feta)", "Cheese (Emmental)", "Cheese (Blue cheese)", "Cheese (Halloumi)", "Cheese (Cottage cheese)", "Greek yogurt", "Skyr", "Sour cream", "Curd", "Clotted cream", "Quark", "Whey", "Kefir", "Sheep milk"],

"Proteins" => ["Chicken", "Salmon", "Cod", "Tuna", "Sardine", "Shrimp", "Tofu", "Eggs", "Lentils", "Chickpeas", "Red beans", "Sausages", "Ham", "Ground beef",
  "Turkey", "Duck", "Pork", "Beef", "Lamb", "Veal", "Trout", "Haddock", "Mackerel", "Anchovies", "Scallops", "Crab", "Lobster", "Octopus", "Squid", "Seitan", "Tempeh", "Black beans", "White beans", "Peas", "Edamame", "Nuts", "Almonds", "Peanut butter", "Sunflower seeds", "Chia seeds", "Flax seeds"],

"Grains & Starches" => ["Rice", "Pasta", "Bread", "Couscous", "Quinoa", "Barley", "Bulgur", "Oats", "Millet", "Corn", "Polenta", "Semolina", "Buckwheat", "Farro", "Rye", "Sorghum", "Amaranth", "Whole wheat", "Brown rice", "Basmati rice", "Jasmine rice", "Wild rice", "Noodles", "Udon", "Soba", "Vermicelli", "Orzo",
    "Gnocchi", "Tortillas", "Crackers"],

"Fruits" => ["Apple", "Banana", "Orange", "Lemon", "Lime", "Grapefruit", "Mandarin", "Pear", "Peach", "Apricot", "Plum", "Cherry", "Strawberry", "Raspberry", "Blackberry", "Blueberry", "Grape", "Watermelon", "Cantaloupe", "Honeydew melon", "Pineapple", "Mango", "Papaya", "Kiwi", "Fig", "Pomegranate", "Coconut",
  "Date", "Persimmon", "Lychee", "Passion fruit", "Dragon fruit", "Guava", "Starfruit", "Cranberry", "Gooseberry", "Mulberry", "Currant", "Avocado"]
}

category_objects = {}

categories.each do |category_name, ingredients|
  # category = Category.find_or_create_by!(name: category_name)
  # category_objects[category_name] = category

  category = Category.find_or_create_by!(name: category_name)

# Vérifier si l'icône est déjà attachée
unless category.icon.attached?
  image_path = Rails.root.join('app', 'assets', 'images', 'category_icons', "#{category_name.downcase}.png")

  if File.exist?(image_path)
    category.icon.attach(io: File.open(image_path), filename: "#{category_name.downcase}.png", content_type: "image/png")
    puts "✅ Image attached for category: #{category_name}"
  else
    puts "⚠️ Image not found for category: #{category_name}"
  end
end


  ingredients.each do |ingredient_name|
    Ingredient.create!(name: ingredient_name, category: category)
  end
end

# Ajout d'ingrédients aux frigos
Fridge.all.each do |fridge|
  Ingredient.all.sample(3).each do |ingredient|
    FridgeIngredient.create!(fridge: fridge, ingredient: ingredient)
  end
end

puts "✅ Seed terminée avec succès !"
