class Message < ActiveRecord::Base
  belongs_to :user

  def self.new_from_template(user)
    template = user.message_templates.first || MessageTemplate.new
    Message.new(subject: template.subject, message: template.message, user_id: user.id)
  end
end
