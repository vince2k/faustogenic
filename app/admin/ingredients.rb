ActiveAdmin.register Ingredient do
  permit_params :name, :carbs, :proteins, :fats, :fibers

  index do
    selectable_column
    id_column
    column :name
    column :carbs
    column :proteins
    column :fats
    column :fibers
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :carbs
      f.input :proteins
      f.input :fats
      f.input :fibers
    end
    f.actions
  end
end
