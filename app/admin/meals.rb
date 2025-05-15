ActiveAdmin.register Meal do
  permit_params :name, :user_id

  index do
    selectable_column
    id_column
    column :name
    column :user
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :user
    end
    f.actions
  end
end
