class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation,params[:id])
      user.activiate
      log_in user
      flash[:success] = "Account Activated"
      redirect_to user
    else
      flash[:danger] = "Activation invalid"
      redirect_to root_url
    end
  end
end
