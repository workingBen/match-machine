class AddMessageCountToUser < ActiveRecord::Migration
  def change
    add_column :users, :messages_count, :integer, default: 0
    User.reset_column_information
    User.find_each do |u|
      User.update_counters u.id, messages_count: u.messages.count
    end
  end
end
