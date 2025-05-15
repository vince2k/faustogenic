ActiveAdmin.register Dish do
  permit_params :name, :meal_id

  index do
    selectable_column
    id_column
    column :name
    column :meal
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :meal
    end
    f.actions
  end
end
