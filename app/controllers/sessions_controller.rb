class SessionsController < ApplicationController
  before_action :kick, only:[:new, :create]
  def new
  end
  
  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      if @user.activated?
        #Log the user in and redirect to the user's show page
        log_in @user 
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
        redirect_back_or(@user)
      else
        flash[:warning] = "Account not activated. Check your email for activation"
        redirect_to root_url
      end
   else
      #Create an error message.
      flash.now[:danger] = 'Invalid email/password' #invalid
      render'new'
    end
  end
  
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
  
  def logg
    unless logged_in?
      flash[:danger] = "Please login"
      redirect_to login_url
    end
  end
  
  #kick back the user when he is already logged in
  def kick
    if logged_in?
      flash[:danger] = "You have already signed in"
      redirect_to user_path(current_user)
    end
  end
end
