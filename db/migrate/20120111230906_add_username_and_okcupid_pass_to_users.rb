class AddUsernameAndOkcupidPassToUsers < ActiveRecord::Migration
  def change
    add_column :users, :username, :string
    add_column :users, :okcupid_pass, :string
  end
end
