ActiveAdmin.register Day do
  permit_params :date, :user_id

  index do
    selectable_column
    id_column
    column :date
    column :user
    actions
  end

  form do |f|
    f.inputs do
      f.input :date, as: :datepicker
      f.input :user
    end
    f.actions
  end
end
