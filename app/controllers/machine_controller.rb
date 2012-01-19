class MachineController < ApplicationController
  NOT_AUTHORIZED = 'Your OkCupid credentials were not authorized.'

  before_filter :require_logged_in_user
  before_filter :set_message_template, only: [:setup, :message]

  def setup
    flash[:error] = NOT_AUTHORIZED unless okcupid_login(current_user, 0)
  end

  def run_machine
    session[:search_query] = get_search_params
    redirect_to machine_match_path
  end
  
  def match
    redirect_to edit_user_registration_path, flash: { error: NOT_AUTHORIZED } unless @html = okcupid_matches(current_user, session[:search_query])
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
 
  # SETUP MACHINE PARAMS
  
  def get_search_params
    search_params = "count=100&update_prefs=1&locid=0&timekey=1&" 
    search_params += jhash(process_filters(params[:search_form]))
    debugger
    search_params
  end

  # GET MATCHES #

  def okcupid_matches(user, search_params)
    resp = http_req :match, search_params, { :username => user.username, :password => user.okcupid_pass }

    process_matches(resp.body.to_s)
  end

  FILTER_MAP = {
    type: 0,
    has_photo: 1,
    radius: 3,
    last_online: 5,
    status: 35,
  }
  ETHNICITY_MAP = {
    asian: 2,
    middle_eastern: 4,
    black: 8,
    native_american: 16,
    indian: 32,
    pacific_islander: 64,
    latin: 128,
    white: 256,
    human: 512
  }

  def process_filters(h)
    ret, c = {}, 0
    h.each do |k,v|
      c+=1
      if f = FILTER_MAP[k.to_sym]
        add_filter(ret, c, "#{f},#{v}")
      elsif k == 'age_begin'
        age_begin = v
      elsif k == 'age_end'
        add_filter(ret, c, "2,#{age_begin},#{v}") if age_begin
      elsif k == 'ethnicity'
        add_filter(ret, c, "9,#{sum_ethnicity(v)}")
      elsif k == 'height'
        add_filter(ret, c, "10,15240#{15240+254*v}")
      else
        c-=1 #decrement the count, we didn't find a filter match
      end
    end
    ret
  end

  def add_filter(h, c, v)
    h["filter"+c.to_s]=v
  end

  # FIXME: can I write this with inject or reduce? gave up bc inject had problems with arrays of string ints
  def sum_ethnicity(h)
    r=0; h.each {|v| r+=ETHNICITY_MAP[v.to_sym] }; r
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
