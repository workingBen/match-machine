class MessageTemplate < ActiveRecord::Base
  attr_accessible :subject, :message, :user_id

  belongs_to :user
end
