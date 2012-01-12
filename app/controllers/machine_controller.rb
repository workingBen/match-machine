class MachineController < ApplicationController
  before_filter :require_logged_in_user

  def setup
  end

  def run
  end

  def matches
  end

  private

  def require_logged_in_user
    redirect_to new_user_session_path unless user_signed_in?
  end
end
