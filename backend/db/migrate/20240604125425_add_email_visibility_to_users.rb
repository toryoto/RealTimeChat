class AddEmailVisibilityToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :is_email_public, :boolean
  end
end
