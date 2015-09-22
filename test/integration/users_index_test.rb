require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:michael)
    @user2 = users(:archer)
  end
  
  test "index including paginate and delete links" do
    log_in_as(@user)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    first_page = User.paginate(page: 1)
    first_page.each do |x|
      assert_select 'a[href=?]', user_path(x), text: x.name
      unless x == @user
        assert_select 'a[href=?]', user_path(x), text: 'delete'
      end
    end
    assert_difference "User.count", -1 do
      delete user_path(@user2)
    end
    assert_redirected_to users_url
  end
  
  test "index as non-admin" do
    log_in_as(@user2)
    get users_path
    assert_select 'a', text:'delete', count: 0
  end
 
end
