require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest

def setup
 ActionMailer::Base.deliveries.clear
 @user = users(:michael)
end

	test "password reset" do
	 get new_password_reset_path
	 assert_template 'password_resets/new'
	 post password_resets_path, params: { password_reset:{email: ""}}
	 assert_not flash.empty?
	 assert_template 'password_resets/new'

	 # メールアドレスが有効 ####################2
	 post password_resets_path, params: { password_reset: { email: @user.email}}
	 assert_not_equal @user.reset_digest, @user.reload.reset_digest
	 assert_equal 1, ActionMailer::Base.deliveries.size
	 assert_not flash.empty?
	 assert_redirected_to root_url

	 # パスワード再設定フォームのテスト ####################3
	 user = assigns(:user)

	 # メールアドレスが無効 ####################4
     get edit_password_reset_path(user.reset_token, email: "")
     assert_redirected_to root_url

	 # 無効なユーザー ####################5
	 user.toggle!(:activated)
	 get edit_password_reset_path(user.reset_token, email: user.email)
	 assert_redirected_to root_url
	 user.toggle!(:activated)

	 # メールアドレスが有効で、トークンが無効 ####################6
	 get edit_password_reset_path("wrong token", email: user.email)
	 assert_redirected_to root_url

	 # メールアドレスもトークンも有効 ####################7
	 get edit_password_reset_path(user.reset_token, email: user.email)
	 assert_template 'password_resets/edit'
	 assert_select "input[name=email][type=hidden][value=?]", user.email

	 # 無効なパスワードとパスワード確認 ####################8
	 patch password_reset_path(user.reset_token), params: { email: user.email,
	                                                       user: {password: "foobaz",
	                                                    password_confirmation: "eeeeee"}}
	 assert_select 'div#error_explanation'

	 # パスワードが空 ####################9
	 patch password_reset_path(user.reset_token), params: { email: user.email,
	                                                       user: {password: "",
	                                                    password_confirmation: ""}}
	 assert_select 'div#error_explanation'

	 # 有効なパスワードとパスワード確認 ####################10
	 patch password_reset_path(user.reset_token), params: { email: user.email,
	                                                       user: {password: "foobaz",
	                                                    password_confirmation: "foobaz"}}
	 assert is_logged_in?
	 assert_nil user.reload.reset_digest
	 assert_not flash.empty?
	 assert_redirected_to user
    end

    test "expired token" do
     get new_password_reset_path
     post password_resets_path, params: { password_reset: { email: @user.email}}
     @user = assigns(:user)
     @user.update_attribute(:reset_sent_at, 3.hours.ago)
     patch password_reset_path(@user.reset_token), params: { email: @user.email,
                                                   user: { password: "foobar",
                                                    password_confirmation: "foobar"}}
    assert_response :redirect
    follow_redirect!
    assert_match /有効期限が切れました/i, response.body
    end

end

