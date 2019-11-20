require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
	
  def setup
    @user = users(:michael)
  end


    test "login with invalid information" do
    get login_path #1
    assert_template 'sessions/new' #2
    post login_path, params: { session: { email: "", password: "" } } #3
    assert_template 'sessions/new'#4
    assert_not flash.empty?
    get root_path#5
    assert flash.empty?#6
    end

    test "login with valid information followed by logout" do#追加
    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    assert is_logged_in?#追加
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    delete logout_path#追加
    assert_not is_logged_in?#追加
    assert_redirected_to root_url#追加
    follow_redirect!#追加
    assert_select "a[href=?]", login_path#追加
    assert_select "a[href=?]", logout_path,      count: 0#追加
    assert_select "a[href=?]", user_path(@user), count: 0#追加
    end
end
