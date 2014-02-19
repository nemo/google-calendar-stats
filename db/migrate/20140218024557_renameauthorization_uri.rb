class RenameauthorizationUri < ActiveRecord::Migration
  def change
    remove_column :users, :authoriziation_uri
    add_column :users, :authorization_uri, :string
  end
end
