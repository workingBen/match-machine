class ApplicationController < ActionController::Base
  protect_from_forgery

  def after_sign_in_path_for(resource)
    machine_setup_path
  end

  # NETWORKING #

  def jhash(hash, spacer = '&') hash.map { |k, v| "#{ k }=#{ v }" }.join spacer end

  def http_req(uri, param_str = nil, params = nil)
    @sess = Patron::Session.new unless @sess
    @sess.timeout = 10
    @sess.base_url = "http://www.okcupid.com/"
    @sess.headers['user-agent'] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0.1) Gecko/20100101 Firefox/8.0.1'
    # set session, authcode and user_id if we have them
    @sess.headers['cookie'] = "data=s; #{jhash(session[:okcupid], '; ')}" if session[:okcupid]

    @sess.post(uri.to_s, param_str || jhash(params))
  end
 
end
