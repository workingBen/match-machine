class MessageTemplatesController < ApplicationController
  def create
    puts "In MessageTemplateController#create"
    @message_template = MessageTemplate.new(params)
    @message_template.save!
    debugger
    puts "after debugger"
  end
end
