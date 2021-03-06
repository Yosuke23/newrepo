require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest

 def setup
  @user = users(:michael)
 end

 test "micropost interface" do
  log_in_as(@user)
  get root_path
  assert_select 'div.pagination'
  assert_select 'input[type=file]'
  assert_no_difference 'Micropost.count' do
   post microposts_path, params: { micropost: { content: ""}}
  end
  assert_select 'div#error_explanation'

  content = "This micropost really ties the room together"
  picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
  assert_difference 'Micropost.count', 1 do
   post microposts_path, params: { micropost: { content: content, picture: picture }}
  end
   user = assigns(:micropost)
   assert user.picture?
   #assert_redirected_to root_path
   follow_redirect!
   assert_match content, response.body

   assert_select 'a', text: "DELETE"
   first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
    delete micropost_path(first_micropost)
  end
   get user_path(users(:archer))
    assert_select 'a', text: "DELETE", count: 0
 end

 test "micropost sidebar count" do
  log_in_as(@user)
  get root_path
  assert_match "#{@user.microposts.count}", response.body
  other_user = users(:malory)
  log_in_as(other_user)
  get root_path
  assert_match "0", response.body
  other_user.microposts.create!(content: "A Micropost")
  get root_path
  assert_match "microposts", response.body
 end
end
