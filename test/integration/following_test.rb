require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:michael)
    @user2 = users(:rider)
    log_in_as(@user)
  end
  
  test "following page" do
    get following_user_path(@user)
    assert_not @user.following.empty?
    assert_match @user.following.count.to_s, response.body
    @user.following.each do |u|
      assert_select "a[href=?]", user_path(u)
    end
  end
  
  test "followers page" do
    get followers_user_path(@user)
    assert_not @user.followers.empty?
    assert_match @user.followers.count.to_s, response.body
    @user.followers.each do |u|
      assert_select "a[href=?]", user_path(u)
    end
  end
  
  test "should follow a user in standard way" do
    assert_difference '@user.following.count', 1 do
      post relationships_path, followed_id: @user2.id
    end
  end
  
  test "should follow a user with Ajax" do
    assert_difference '@user.following.count', 1 do
      xhr :post, relationships_path, followed_id: @user2.id
    end
  end
  
  test "should unfollow user in standard way" do
    @user.follow(@user2)
    relationship = @user.active_relationships.find_by(followed_id: @user2.id)
    assert_difference '@user.following.count', -1 do
      delete relationship_path(relationship)
    end
  end
  
  test "should unfollow user with Ajax" do
    @user.follow(@user2)
    relationship = @user.active_relationships.find_by(followed_id: @user2.id)
    assert_difference '@user.following.count', -1 do
      xhr :delete, relationship_path(relationship)
    end
  end
end
