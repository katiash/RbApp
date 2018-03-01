class SessionsController < ApplicationController
  
  # session[:user_id] should already exist to be "destroyed".
  # otherwise, redirect to "sessions/new" to "create" a session[:user_id] /i.e. to login.
  
  # >>>>>>>>>>>>>>>
  skip_before_action :require_login, except:[:destroy]
  # >>>>>>>>>>>>>>>
  
  # render 'Login' page
  def main
    if current_user
      redirect_to '/groups' #groups_path
    end
  end

  # login / create session[:user_id]: 
  # route: post "sessions" => "sessions#create"
  # =================================================
  def create
    puts "I am in sessions create method with params.inspect of #{params.inspect}"
    puts "I am in sessions create method with params for user of #{params[:user]}"
    puts "I am in sessions create method with params of user's email #{params[:user][:email]}"

    #TEST with LOWER case (as when saved to database):
    email = params[:user][:email]
    email.downcase!
    @user=User.find_by_email(email).try(:authenticate, params[:user][:password])
    puts "Printing response from try to authenticate in sessions create method (null or user, or false):  #{@user}"
    
    # THIS IS WHERE SESSION GETS SET:
    # ================================
    if @user #(if !null or !false)
      session[:user_id]=@user.id
      # Authenticate is true
      # -> save user id to session
      # -> redirect_to users profile page (i.e. get 'users/:id')
      redirect_to "/groups"
    else
      puts "...Authenticate must have not found user or not authenticated. Displaying two flash errors on redirect to login..."
      # If authenticate false or null,
      # 1) add an error message:
      # ====================================
      # flash[:notice] = ["Message 1"]
      # flash[:notice] << "Message 2"
      # AND IN VIEW: 
      # <%= flash[:notice].join("<br>") %>
      # ====================================
      flash[:errors] = ["Invalid Login."]
      flash[:errors] << "Incorrect Email or Wrong Password detected!"
      # NOTE: "notice" and "alert" are very common keys in flash:
      # *****************************************************************
      # redirect_to root_url, flash: { referral_code: 1234 }
      # redirect_to root_url, notice: "You have successfully logged out." 
      # redirect_to root_url, alert: "You're stuck here!"
      # ******************************************************************
      # 2) and redirect_to 'login' view:
      redirect_to '/sessions/main'
      # Can ALSO simply *render* on unsuccessful submit, with flash.now[:error]=["Invalid Login"], 
      # to display flash *now*, instead of on next redirect. 
      # (NOTE: also use flash.keep to persist for yet another redirect if used on next action to *catch it*)
      # ( render 'new' # renders the 'new.html.erb' in the sessions controller.)
    end
  end
  
  def destroy
    # Log User Out

    puts "In sessions controller, *destroy*/logout method with params: ", params.inspect
    puts "What's in session hash before session.clear: ", session
    puts "current_user is: ", current_user
    puts "flash[:notice] is : ", flash[:notice].inspect

    flash[:notice]=["#{current_user.first_name} #{current_user.last_name}  is now logged out!"]
    session.clear # or reset.session or session[:user_id].destroy

    puts "What's in session hash after session.clear: ", session
    puts "flash[:notice] is : ", flash[:notice].inspect
    redirect_to '/sessions/main'
  end

end