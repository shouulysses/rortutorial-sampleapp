require 'test_helper'

class MicropostsControllerTest < ActionController::TestCase
  
  def setup
    @micropost = microposts(:saber)
  end

  test "should redirect create when not log in" do
    assert_no_difference "Micropost.count" do
      post :create, micropost: { content: "Here I am" }
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when not log in" do
    assert_no_difference "Micropost.count" do
      delete :destroy, id: @micropost
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy for wrong micropost" do 
    log_in_as(users(:michael))
    micropost = microposts(:saber)
    assert_no_difference "Micropost.count" do
      delete :destroy, id: micropost
    end
    assert_redirected_to root_url
  end

end
