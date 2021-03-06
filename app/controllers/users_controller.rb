class UsersController < ApplicationController
    before_action :logged_in_user, only: [:edit, :update, :index, :destroy, :following, :followers]
    before_action :correct_user, only: [:edit, :update]
    before_action :admin_user, only: [:destroy]
   # before_action :login_nosign, only:[:new]
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    redirect_to root_url and return unless @user.activated?
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)    # Not the final implementation!
    if @user.save
      # Handle a successful save.
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile Updated"
      redirect_to @user
      #update
    else
      render 'edit'
    end
  end
  
  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  
  def following 
    @title = "following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end
  
  def followers
    @title = "followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end
  
  
private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end
  
  #before fitters

  #Confirms the user is correct
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end
  
  #Confirms the user is admin
  def admin_user
    redirect_to (root_url) unless current_user.admin?
  end
  
  #no sign up when logged in
  def login_nosign
    if logged_in?
      flash[:danger] = "No signup while logged in"
      redirect_to(current_user)
    end
  end
    
end
