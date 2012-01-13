module MachineHelper
  def hover_nav
    content_tag :div, class: 'hover_nav', style: 'display: none;' do
      button_to('View', root_path) + 
      button_to('Message', root_path, confirm: "Are you sure?")
    end
  end
end
