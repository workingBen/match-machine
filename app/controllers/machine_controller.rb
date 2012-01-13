class MachineController < ApplicationController
  NOT_AUTHORIZED = 'Your OkCupid credentials were not authorized.'
  before_filter :require_logged_in_user

  def setup
    flash[:error] = NOT_AUTHORIZED unless okcupid_login(current_user)
  end

  def matches
    redirect_to edit_user_registration_path, flash: { error: NOT_AUTHORIZED } unless @html = okcupid_matches(current_user)
  end

  private

  # BEFORE FILTERS #
  
  def require_logged_in_user
    redirect_to new_user_session_path unless user_signed_in?
  end

  # LOGIN #

  def okcupid_login(user)
    resp = http_req :login, { :p => nil, :username => user.username, :password => user.okcupid_pass }
    store_credentials_from_resp(resp)
  end

  def store_credentials_from_resp(resp)
    begin
      session[:okcupid] ||= {}
      session[:okcupid][:session] = resp.headers["Set-Cookie"].to_s.scan(/session=[0-9a-zA-Z%]*/)[0].gsub('session=', '')
      #session[:okcupid][:authlink] = resp.headers["Set-Cookie"].to_s.scan(/authlink=[0-9a-zA-Z%]*/)[0].gsub('authlink=', '')
      #session[:okcupid][:user_id] = resp.body.scan(/au=[0-9a-zA-Z]*/)[0].gsub('au=', '')
      true
    rescue Exception => e
      false
    end
  end
  
  # GET MATCHES #

  def okcupid_matches(user)
    # TODO: put search_params inside params hash 
    search_params = "count=100&filter1=0,34&filter2=2,21,28&filter3=3,25&filter4=5,604800&filter5=1,1&filter6=35,2&filter7=9,2&filter8=12,28&filter9=13,6&filter10=18,8&filter11=10,15240,17272&locid=0&timekey=1&sort1=2,80&sort2=8,100&sort3=7,10&sort4=4,10&sort5=0,20&matchSortRelative=1&custom_search=0&fromWhoOnline=0&mygender=m&update_prefs=1&sort_type=0&sa=1&using_saved_search=" 
    resp = http_req :match, { :username => user.username, :password => user.okcupid_pass }, search_params

    process_matches(resp.body.to_s)
  end

  def process_matches(parsed_url)
    require 'nokogiri'

    html = ''
    doc = Nokogiri::HTML(parsed_url)
    doc.css('div.match_row').each do |node|
      html << "<div class='wrapper'>"
      html << node.css('div.user_info').to_s.gsub('/profile/', 'http://www.okcupid.com/profile/') + "\n"
      html << node.css('div.percentages').to_s + "\n"
      #html << '<div class="hover_nav" style="display: none;">view | message</div>' + "\n"
      html << view_context.hover_nav + "\n"
      html << "</div>"
    end
    html.present? ? html : nil
  end

  # NETWORKING #

  def jhash(hash, spacer = '&') hash.map { |k, v| "#{ k }=#{ v }" }.join spacer end

  def http_req(uri, params = nil, param_str = nil)
    @sess = Patron::Session.new unless @sess
    @sess.timeout = 10
    @sess.base_url = "http://www.okcupid.com/"
    @sess.headers['user-agent'] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0.1) Gecko/20100101 Firefox/8.0.1'
    # set session, authcode and user_id if we have them
    @sess.headers['cookie'] = "data=s; #{jhash(session[:okcupid], '; ')}" if session[:okcupid]

    @sess.post(uri.to_s, param_str || jhash(params))
  end
 
end
