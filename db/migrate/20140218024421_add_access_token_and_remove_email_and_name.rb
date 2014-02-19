class AddAccessTokenAndRemoveEmailAndName < ActiveRecord::Migration
  def change
    add_column :users, :access_token, :string
    remove_column :users, :email
    remove_column :users, :name
  end
end
