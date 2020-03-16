require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
include ApplicationHelper

def setup
 @user = users(:michael)
end

test "profile display" do
 get user_path(@user)
 assert_template 'users/show'
 assert_select 'title', full_title(@user.name)
 assert_select 'h1', text: @user.name
 assert_select 'h1>img.gravatar'
 assert_match @user.microposts.count.to_s, response.body
 assert_select 'div.pagination', count: 1
  @user.microposts.paginate(page: 1).each do |micropost|
  assert_match micropost.content, response.body
  end
  assert_select 'div.stats'
  assert_select 'strong#following.stat' 
  assert_select "a[href=?]", following_user_path(@user)
  assert_select "a[href=?]", followers_user_path(@user)
  assert_match @user.active_relationships.count.to_s, response.body
  assert_match @user.passive_relationships.count.to_s, response.body
 end

 test "stats for following and followers" do
  log_in_as(@user)
  get root_path
  assert_template 'static_pages/home'
  assert_select 'div.stats'
  assert_select 'strong#following.stat' 
  assert_select "a[href=?]", following_user_path(@user)
  assert_select "a[href=?]", followers_user_path(@user)
  assert_match @user.active_relationships.count.to_s, response.body
  assert_match @user.passive_relationships.count.to_s, response.body
 end
end
