class PasswordResetsController < ApplicationController
  def new
  end
 
  def create
    @user = User.find_by(email: params[:password_resets][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_reset_email
      flash[:info] = "Please check your email for reset instruction"
      redirect_to root_url
    else
      flash.now[:danger] = "No such email"
      render 'new'
    end
  end
 
  def edit
  end
  
 
end
