# Création des utilisateurs
User.find_or_create_by!(email: "user@example.com") do |user|
  user.password = "password"
  user.password_confirmation = "password"
end

AdminUser.find_or_create_by!(email: "admin@example.com") do |admin|
  admin.password = "password"
  admin.password_confirmation = "password"
end

# Création des ingrédients
ingredients = [
  { name: "Poulet", carbs: 0, proteins: 27, fats: 3.6, fibers: 0 },
  { name: "Laitue", carbs: 2.9, proteins: 1.2, fats: 0.2, fibers: 1.2 },
  { name: "Parmesan", carbs: 3.2, proteins: 35.8, fats: 25, fibers: 0 },
  { name: "Tomate", carbs: 3.9, proteins: 0.9, fats: 0.2, fibers: 1.2 },
  { name: "Croutons", carbs: 68, proteins: 11, fats: 3.9, fibers: 5 }
]

ingredients.each do |ingredient|
  Ingredient.find_or_create_by!(name: ingredient[:name]) do |i|
    i.carbs = ingredient[:carbs]
    i.proteins = ingredient[:proteins]
    i.fats = ingredient[:fats]
    i.fibers = ingredient[:fibers]
  end
end

# Création des recettes
caesar_recipe = Recipe.find_or_create_by!(name: "Salade César") do |recipe|
  recipe.description = "La classique salade César avec poulet, laitue, parmesan et croutons."
end

# Création des plats
meal = Meal.find_or_create_by!(name: "Déjeuner César", user: User.first)
dish = Dish.find_or_create_by!(name: "Salade César", meal: meal)

# Ajout des ingrédients au plat
DishIngredient.find_or_create_by!(dish: dish, ingredient: Ingredient.find_by(name: "Poulet"), quantity: 150)
DishIngredient.find_or_create_by!(dish: dish, ingredient: Ingredient.find_by(name: "Laitue"), quantity: 100)
DishIngredient.find_or_create_by!(dish: dish, ingredient: Ingredient.find_by(name: "Parmesan"), quantity: 30)
DishIngredient.find_or_create_by!(dish: dish, ingredient: Ingredient.find_by(name: "Croutons"), quantity: 20)

# Ajout de la recette au plat
DishRecipe.find_or_create_by!(dish: dish, recipe: caesar_recipe)

puts "Données de test créées avec succès."
