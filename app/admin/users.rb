ActiveAdmin.register User do
  permit_params :email, :nickname, :first_name, :last_name, :password, :password_confirmation

  index do
    selectable_column
    id_column
    column :email
    column :nickname
    column :first_name
    column :last_name
    column :created_at
    column :updated_at
    actions
  end

  filter :email
  filter :nickname
  filter :first_name
  filter :last_name
  filter :created_at
  filter :updated_at

  form do |f|
    f.inputs do
      f.input :email
      f.input :nickname
      f.input :first_name
      f.input :last_name
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

end
