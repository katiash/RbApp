class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # ADDED ON BELOW CONTROLLER FILTERS:
  # ============================
  # If a filter 'renders' or 'redirects', *action* does NOT run. 
  # ( Can return, but that is not the intention of these filter methods.)
  # If they do NOT 'render' or 'redirect' => *action*.
  before_action :require_login

  # DEFINE ANY METHODS AS HELPER_METHODS (available to ALL VIEWS):
  # =============================================================
  helper_method :current_user
  helper_method :require_login
  
  # SHARE METHOD TO ALL CONTROLLERS AND VIEWS VIA:
  # =================================================
  # (initializes "current_user" object carefully, - checks if session[:user_id] exists first)
  # 1. (application_controller.rb methods are available to ALL METHODS)
  # def current_user
  #  Will only try to find if session[:user_id] evaluates to true (not nil or false)
  #  User.find(session[:user_id]) if session[:user_id] 
  # end 
  # 2. ( "helper_method" makes a referred to method available to ALL VIEWS !
  # helper_method :current_user
  # ==================================================

  # CAN ALSO DO THIS (then set 'current_user' within "require_login" method):
  # =========================================================================
  # def current_user
  #   require_login 
  # end 
  # helper_method :current_user

  # PRIVATE vs PUBLIC HELPER_METHOD AND FILTER METHODS:
  # ===================================================
  # 1. Why PRIVATE? Because you don’t want these methods to be accessible to your users. 
  # Users can’t hit that method. While unlikely, it’s possible that you might have 
  # a route defined that points to this method as an action. 
  # 2. Making non-action methods privates ALSO makes your code a bit more clear by declaring
  # that these methods are NOT accessible via any routes. So, simply put, you should 
  # make the non-action methods private because it’s a best practice.

  # REQIURE SOMEONE TO BE LOGGED IN ( i.e. session[:user_id] exists ) VIA:
  # ======================================================================
  # Below, if current_user is undefined, it sets it to session[:user_id], BUT not before it finds it!
  # a ||= b means, if a is undefined, then assign it the value of b, otherwise leave it alone.
  # With && the right operand is not evaluated if the left operand is falsy.
  # With || the right operand is not evaluated if the left operand is truthy.
  # @@count =0;
  
  private

  def current_user
    # puts "#{@@count}" 
    # @@count+=1;
    # puts "#{@@count} using current_user private method to set current_user"
    current_user ||= session[:user_id] && User.find(session[:user_id])
  end

  # current_user AND require_login (in 1 method):
  # ===========================================================================
  def require_login  
    # puts "#{@@count}" 
    # @@count+=1;   
    if !(session[:user_id])
      # puts "#{@@count} require_login method of application controller found no user logged in: ", session[:user_id]
      redirect_to '/main'
    # else
      # puts "#{@@count} using require_login private method: Someone is already logged in: ", session[:user_id]
      # current_user = User.find(session[:user_id])
      #return current_user
    end
  end

end
