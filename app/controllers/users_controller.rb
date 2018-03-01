class UsersController < ApplicationController
  # >>>>>>>>>>>>>>>>>
  skip_before_action :require_login, except:[:show]
  # >>>>>>>>>>>>>>>>>

  # post "users" => "users#create" (registration form on 'main' view)
  def create
    @user=User.new(user_create_params)
    if @user.save
      flash[:notice] = ["Registration Successful! Please Login to enter the Organizations Dashboard App!"]
      redirect_to "/" #redirects to the login view, sessions controller
    else
      flash.now[:notice] = ["User was not created. See errors below."]
      puts "Errors to display to client for new user create", @user.errors.full_messages
      flash.now[:errors] = @user.errors.full_messages
      render 'main'
    end
  end

  private

  def user_create_params
    params.require(:user).permit(:first_name, :last_name, :email, :password)
  end
end
