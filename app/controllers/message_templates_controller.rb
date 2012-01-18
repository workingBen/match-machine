class MessageTemplatesController < ApplicationController
  def create
    @message_template = MessageTemplate.create!(params[:message_template])
  end

  def update
    @message_template = MessageTemplate.find(params[:id])
    @message_template.update_attributes(params[:message_template])
  end
end
