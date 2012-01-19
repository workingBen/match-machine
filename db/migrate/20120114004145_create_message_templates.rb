class CreateMessageTemplates < ActiveRecord::Migration
  def change
    create_table :message_templates do |t|
      t.string :subject
      t.text :message
      t.integer :user_id

      t.timestamps
    end
  end
end
