class AddDefaultToIsEmailPublicForExistingUsers < ActiveRecord::Migration[6.0]
  def up
    change_column_default :users, :is_email_public, from: nil, to: false

    User.where(is_email_public: nil).update_all(is_email_public: false)
  end

  def down
    change_column_default :users, :is_email_public, from: false, to: nil
  end
end
