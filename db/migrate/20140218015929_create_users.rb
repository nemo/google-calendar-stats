class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :client_id
      t.string :authoriziation_uri
      t.string :client_secret
      t.integer :expires_in
      t.string :refresh_token
      t.string :token_credential_uri
      t.integer :issued_at
      t.string :email
      t.string :name

      t.timestamps
    end
  end
end
