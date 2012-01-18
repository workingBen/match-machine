class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :subject
      t.text :message
      t.integer :user_id
      t.string :sent_to_username

      t.timestamps
    end
  end
end
