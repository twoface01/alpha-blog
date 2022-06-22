class ApplicationController < ActionController::Base
  
  helper_method :current_user, :logged_in?
  
  def current_user
    # return current user if it exists, otherwise query the database
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  def logged_in?
    # bang bang turns the value to a boolean
    !!current_user
  end
  
end
