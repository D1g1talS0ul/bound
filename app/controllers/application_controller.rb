require 'authie/session'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :login_required
  rescue_from Authie::Session::InactiveSession, :with => :login_required
  rescue_from Authie::Session::ExpiredSession, :with => :login_required
  rescue_from Authie::Session::BrowserMismatch, :with => :login_required

  private

  def login_required
    unless logged_in?
      redirect_to login_path
    end
  end

  def changes_pending
    @changes_pending ||= Change.pending.count
  end
  helper_method :changes_pending

  def redirect_to_with_return_to(url, *args)
    if params[:return_to].blank? || !params[:return_to].starts_with?('/')
      redirect_to url, *args
    else
      redirect_to params[:return_to], *args
    end
  end

end
