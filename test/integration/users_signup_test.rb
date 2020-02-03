require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
   ActionMailer::Base.deliveries.clear
  end

  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name:  "",
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
     end

    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
   #assert_select 'form[action="/signup"]'
  end

  test "valid signup infomation with account activation" do
    get signup_path 
    assert_difference 'User.count', 1 do
      post users_path,params: { user: { name: "Example User",
                                        email: "user@example.com",
                                        password:    "password",
                                        password_confirmation: "password" }}
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
	  user = assigns(:user)
	  assert_not user.activated?
    # 有効化していない状態でログインしてみる↓
    log_in_as(user)
    assert_not is_logged_in?
    # 有効化トークンが不正な場合↓
    get edit_account_activation_path("invalid token", email: "wrong")
    assert_not is_logged_in?
    # トークンは正しいがメールアドレスが無効な場合↓
    get edit_account_activation_path(user.activation_token, email: "wrong")
    assert_not is_logged_in?
    # 有効化トークンが正しい場合↓
    get edit_account_activation_path(user.activation_token, email: user.email)
    # userをreloadで更新して有効化された状態にDB情報を更新↓
    assert user.reload.activated?
    # ↓[account_activations_controller.rb]のeditアクション内で最初のif文クリア（有効化成功）の結果処理にあたるredirect_to userになるため、このfollow_redirect!をここに書くことで、redirect_to userが実行されます。
    follow_redirect!
	  assert_template 'users/show'
    assert_not flash.empty?
    assert is_logged_in?
  end
end
