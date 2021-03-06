require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    ActionMailer::Base.deliveries.clear
  end
  
  
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: { name: "",
                               email: "user@invalid",
                               password: "foo",
                               password_confirmation: "bar"}
      end
    assert_template 'users/new'
    assert_select "div#error_explanation"
    assert_select "div.field_with_errors"
  end
  
  test "valid signup information with account activation" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, user: { name:"abc",
                               email: "abc@valid.com",
                               password: "123456",
                               password_confirmation: "123456"}
      end
      assert_equal 1, ActionMailer::Base.deliveries.size
      user = assigns(:user)
      assert_not user.activated?
      #Try to login before activation
      log_in_as(user)
      assert_not is_logged_in?
      #Invalid activation token
      get edit_account_activation_path("invalid token")
      assert_not is_logged_in?
      #Valid token, invalid email
      get edit_account_activation_path(user.activation_token, email: 'wrong')
      assert_not is_logged_in?
      #Valid token, valid email
      get edit_account_activation_path(user.activation_token, email: user.email)
      assert user.reload.activated?
      follow_redirect!
      assert_template 'users/show'
      assert_not flash.empty?
      assert is_logged_in?
  end
  
end
