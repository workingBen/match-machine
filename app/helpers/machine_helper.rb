module MachineHelper
  def hover_nav(username, essay)
    content_tag :div, class: "hover_nav #{username}", style: 'display: none;' do
      button_to('View', 'http://www.okcupid.com/profile/'+username, class: 'view_user', method: 'get') + 
      button_to('Message', new_message_path(sent_to_username: username), remote: true, method: :get) + 
      essay.html_safe
    end
  end
end

