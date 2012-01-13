class MachineController < ApplicationController
  before_filter :require_logged_in_user

  def setup
    flash[:error] = 'Your OkCupid credentials were not authorized.' unless okcupid_login(current_user)
  end

  def run
  end

  def matches
  end

  private

  def require_logged_in_user
    redirect_to new_user_session_path unless user_signed_in?
  end

  def okcupid_login(user)
    resp = http_req :login, { :p => nil, :username => user.username, :password => user.okcupid_pass }
    
    store_credentials_from_resp(resp)
  end

  def jhash(hash, spacer = '&') hash.map { |k, v| "#{ k }=#{ v }" }.join spacer end

  def http_req(uri, params = nil)
    @sess = Patron::Session.new unless @sess
    @sess.timeout = 10
    @sess.base_url = "http://www.okcupid.com/"
    @sess.headers['User-Agent'] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0.1) Gecko/20100101 Firefox/8.0.1'
    # set session, authcode and user_id if we have them
    @sess.headers['Cookie'] = "data=s; #{jhash(session[:okcupid], '; ')}" if session[:okcupid]

    @sess.post(uri.to_s, jhash(params))
  end

  def store_credentials_from_resp(resp)
    begin
      session[:okcupid] ||= {}
      session[:okcupid][:session] = resp.headers["Set-Cookie"].to_s.scan(/session=[0-9a-zA-Z%]*/)[0].gsub('session=', '')
      session[:okcupid][:authcode] = resp.headers["Set-Cookie"].to_s.scan(/authlink=[0-9a-zA-Z%]*/)[0].gsub('authlink=', '')
      session[:okcupid][:user_id] = resp.body.scan(/au=[0-9a-zA-Z]*/)[0].gsub('au=', '')
      true
    rescue
      false
    end
  end
  
end
