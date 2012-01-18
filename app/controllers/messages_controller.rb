class MessagesController < ApplicationController
  def new
    @message = Message.new_from_template(current_user)
    @message.sent_to_username = params[:sent_to_username]
  end

  def create
    @message = Message.create!(params[:message])
    send_message(@message)
  end
 
  protected
  # SEND MESSAGE #
  
  def send_message(message)
    resp = http_req :mailbox, nil, { :ajax => 1, :sendmsg => 1, :r1 => message.sent_to_username, :subject => message.subject, :body => message.message, :threadid => 0, :authcode => session[:okcupid][:authcode], :reply => 0, :_ => nil }
  end
end
