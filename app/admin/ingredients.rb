ActiveAdmin.register Ingredient do
  permit_params :name, :ciqual_code, :source, :energy_kcal, :ratio, :fats, :carbs, :sugars, :proteins, :fibers, :food_group_id

  index do
    selectable_column
    id_column
    column :name
    column :ciqual_code
    column :source
    column :energy_kcal
    column :ratio
    column :fats
    column :carbs
    column :sugars
    column :proteins
    column :fibers
    column :food_group
    actions
  end

  # filter :source, as: :select, collection: ['Manual', 'Ciqual', 'OpenFoodFacts']
  # filter :food_group

  form do |f|
    f.inputs do
      f.input :name
      f.input :ciqual_code
      f.input :source, as: :select, collection: ['Manual', 'Ciqual', 'OpenFoodFacts']
      f.input :energy_kcal
      f.input :ratio
      f.input :fats
      f.input :carbs
      f.input :sugars
      f.input :proteins
      f.input :fibers
      f.input :food_group, as: :select, collection: FoodGroup.all.map { |g| [g.name, g.id] }
    end
    f.actions
  end
end
