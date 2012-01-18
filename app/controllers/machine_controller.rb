class MachineController < ApplicationController
  NOT_AUTHORIZED = 'Your OkCupid credentials were not authorized.'
  before_filter :require_logged_in_user
  before_filter :set_message_template, only: [:setup, :message]

  def setup
    flash[:error] = NOT_AUTHORIZED unless okcupid_login(current_user, 0)
  end
  
  def run_machine
    redirect_to machine_matches_path
  end

  def matches
    redirect_to edit_user_registration_path, flash: { error: NOT_AUTHORIZED } unless @html = okcupid_matches(current_user)
  end

  private

  # BEFORE FILTERS #
  
  def require_logged_in_user
    redirect_to new_user_session_path unless user_signed_in?
  end

  def set_message_template
    @message_template = current_user.message_templates.last || MessageTemplate.new
  end

  # LOGIN #

  def okcupid_login(user, count)
    resp = http_req :login, nil, { :p => nil, :username => user.username, :password => user.okcupid_pass }
    store_credentials_from_resp(resp, count)
  end

  def store_credentials_from_resp(resp, count)
    begin
      session[:okcupid] ||= {}
      session[:okcupid][:session] = resp.headers["Set-Cookie"].to_s.scan(/session=[0-9a-zA-Z%]*/)[0].gsub('session=', '')
      session[:okcupid][:authcode] = resp.body.to_s.scan(/authid=[0-9a-zA-Z%]*/)[0].gsub('authid=', '')
      session[:okcupid][:user_id] = resp.body.scan(/au=[0-9a-zA-Z]*/)[0].gsub('au=', '')
      true
    rescue Exception => e
      # FIXME: this is a crazy hack because it seems you need to set session before getting an authcode. I think this is because the first redirect should set session in the cookies, but probably isn't. Thus it takes two full round trips to get all the info
      unless count >= 1
        okcupid_login(current_user, count+1) 
      else
        debugger
      end
    end
  end
  
  # GET MATCHES #

  def okcupid_matches(user)
    # TODO: put search_params inside params hash 
    search_params = "count=100&filter1=0,34&filter2=2,21,28&filter3=3,25&filter4=5,604800&filter5=1,1&filter6=35,2&filter7=9,2&filter8=12,28&filter9=13,6&filter10=18,8&filter11=10,15240,17272&locid=0&timekey=1&sort1=2,80&sort2=8,100&sort3=7,10&sort4=4,10&sort5=0,20&matchSortRelative=1&custom_search=0&fromWhoOnline=0&mygender=m&update_prefs=1&sort_type=0&sa=1&using_saved_search=" 
    resp = http_req :match, search_params, { :username => user.username, :password => user.okcupid_pass }

    process_matches(resp.body.to_s)
  end

  def process_matches(parsed_url)
    require 'nokogiri'

    html = ''
    doc = Nokogiri::HTML(parsed_url)
    doc.css('div.match_row').each do |node|
      row_username = node.to_s.scan(/id=\"usr-[a-zA-Z0-9\-_]*"/)[0].gsub('id="usr-', '').gsub('"', '')
      html << "<div class='wrapper'>"
      html << node.css('div.user_info').to_s.gsub('/profile/', 'http://www.okcupid.com/profile/') + "\n"
      html << node.css('div.percentages').to_s + "\n"
      essay = node.css('div.essay').to_s + "\n"
      html << view_context.hover_nav(row_username, essay) + "\n"
      html << "</div>"
    end
    html.present? ? html : nil
  end

end
