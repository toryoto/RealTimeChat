class AddDefaultToIsEmailPublic < ActiveRecord::Migration[6.0]
  def change
    change_column_default :users, :is_email_public, from: nil, to: false
  end
end
