require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "123456", password_confirmation: "123456")
  end
  
  test "should be valid" do
    assert @user.valid?
  end
  
  test "name should be present" do
    @user.name = "     "
    assert_not @user.valid?
  end
  
  test "email should be present" do
    @user.email = "    "
    assert_not @user.valid?
  end
  
  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end
  
  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end
  
  test "email validation should accept valid addresses" do
    valid_add = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_add.each do |valid_a|
      @user.email = valid_a
      assert @user.valid?, "#{valid_a.inspect} should be valid"
    end
  end
  
  test "email validation should reject invalid addresses" do
    invalid_add = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com aaa@a...com]
    invalid_add.each do |invalid_a|
      @user.email = invalid_a
      assert_not @user.valid?, "#{invalid_a.inspect} should be invalid"
    end
  end
  
  test "email should be unique" do
    duplicate = @user.dup
    duplicate.email = @user.email.upcase
    @user.save
    assert_not duplicate.valid?
  end
  
  test "password should be present" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end
  
  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
  
  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember,'')
  end
  
  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "I am a post")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end
  
  test "should follow and unfollow a user" do
    saber = users(:saber)
    archer = users(:archer)
    assert_not saber.following?(archer)
    saber.follow(archer)
    assert saber.following?(archer)
    assert archer.followers.include?(saber)
    saber.unfollow(archer)
    assert_not saber.following?(archer)
  end
  
  test "feed should have the right posts" do
    michael = users(:michael)
    saber = users(:saber)
    caster = users(:caster)
    #Posts from followed user
    saber.microposts.each do |post|
      assert michael.feed.include?(post)
    end
    #Posts from self
    michael.microposts.each do |post|
      assert michael.feed.include?(post)
    end
    #Posts from unfollowing user
    caster.microposts.each do |post|
      assert_not caster.feed.include?(post)
    end
  end
    
    
  
end