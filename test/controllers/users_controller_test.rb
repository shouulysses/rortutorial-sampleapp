require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  
  def setup
    @user = users(:michael) #admin
    @user2 = users(:saber)
    @user3 = users(:archer) #not activated
  end
  
  test "should get new" do
    get :new
    assert_response :success
  end
  
  test "should redirect edit when not logged in" do
    get :edit, id: @user
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "should redirect update when not logged in" do
    get :update, id: @user, user: {name: @user.name, email: @user.email}
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as(@user2)
    get :edit, id: @user
    assert flash.empty?
    assert_redirected_to root_url
  end
  
  test "should redirect update when logged in as wrong user" do
    log_in_as(@user2)
    get :update, id: @user, user: {name: @user.name, email: @user.email}
    assert flash.empty?
    assert_redirected_to root_url
  end
  
  test "should redirect index when not logged in" do
   get :index
   assert_redirected_to login_url
  end
  
  test "should redirect destroy when not logged in" do
    assert_no_difference "User.count" do
      delete :destroy, id: @user
    end
    assert_redirected_to login_url
  end
  
  test "should redirect to Home page when user not admin" do
    log_in_as(@user2)
    assert_no_difference "User.count" do
      delete :destroy, id: @user
    end
    assert_redirected_to root_url
  end
  
  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@user2)
    assert_not @user2.admin?
    patch :update, id:@user2, user: {password: 'password',
                                     password_confirmation: 'password',
                                     admin: true}
    assert_not @user2.reload.admin?
  end
  
  test "getting into non-activated profile will get back to root" do
    log_in_as(@user)
    get :show, id: @user2
    assert_template "users/show"
    get :show, id: @user3
    assert_redirected_to root_url
  end

  test "should redirect following when not logged in" do
    get :following, id: @user
    assert_redirected_to login_url
  end
  
  test "should redirect followers when not logged in" do
    get :followers, id: @user
    assert_redirected_to login_url
  end
end
