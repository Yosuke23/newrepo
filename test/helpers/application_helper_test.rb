require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal full_title,         "Cherish"
    assert_equal full_title("info"), "info | Cherish"
  end
end