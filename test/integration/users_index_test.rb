require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

	 def setup
	  @admin = users(:michael)
	  @non_admin = users(:archer)
	 end

	 test "index as admin including pagination and delete links" do
	  log_in_as(@admin)
	  get users_path
	  assert_template 'users/index'
	  assert_select 'div.pagination'
	  first_page_users = User.paginate(page: 1)
	  first_page_users.each do |user|
	  	assert_select 'a[href=?]', user_path(user), text: user.name
	   unless user == @admin
	  	 assert_select 'a[href=?]', user_path(user), text: 'DELETE'
	  	end
	  end
	   assert_difference 'User.count', -1 do
	   delete user_path(@non_admin)
	  end
 	end
	  test "index as non-admin" do
	   log_in_as(@non_admin)
	   get users_path
	   assert_select 'a', text: 'DELETE', count: 0
	  end

	test "Only activated users will be shown on the index page" do #自作
	get signup_path #サインアップ画面にアクセス
		post users_path,params: { user: { name: "Example User",
	                                email: "user@example.com",
	                                password:    "password",
	                                password_confirmation: "password" }} #有効な情報でサインアップ
		user = assigns(:user) # showアクションの@userを呼び出しこのアクションを通過した新規ユーザーを代入
	assert_not user.activated? # そのユーザーが有効化されていないことをテスト
	log_in_as(@admin) #管理者でログイン
	get users_path #indexページにアクセス
	assert_template 'users/index' #indexページ描画確認
	assert_select 'a[href=?]', user_path(user),false #indexページに無効ユーザーのshowページリンクが存在しないことを確認
	end

	test "Return unactivated users to root" do #自作
	get signup_path #サインアップ画面にアクセス
		post users_path,params: { user: { name: "Example User",
	                                email: "user@example.com",
	                                password:    "password",
	                                password_confirmation: "password" }} #有効な情報でサインアップ
		user = assigns(:user) # showアクションの@userを呼び出しこのアクションを通過した新規ユーザーを代入
	assert_not user.activated? # そのユーザーが有効化されていないことをテスト
	log_in_as(@admin) #管理者でログイン
	get user_path(user) #管理者ログイン状態で有効化されていないユーザーのshowページにアクセス
	assert_redirected_to root_url #showアクションのredirect_to root_url and return unless @user.activated?の処理通りroot_urlにリダイレクトされているかテスト
	end
end
