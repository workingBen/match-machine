module MachineHelper
  def hover_nav(username)
    content_tag :div, class: 'hover_nav', style: 'display: none;' do
      button_to('View', 'http://www.okcupid.com/profile/'+username, class: 'view_user', method: 'get') + 
      button_to('Message', machine_message_path(username: username), confirm: "Are you sure?", remote: true)
    end
  end
end

#onclick="this.form.target='_blank';return true;"
