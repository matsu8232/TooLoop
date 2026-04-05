require "test_helper"

class ItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      name: "テストユーザー",
      email: "items_test@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
  end

  test "new redirects to login when not signed in" do
    get new_item_url
    assert_redirected_to new_user_session_path
  end

  test "new succeeds when signed in" do
    sign_in @user
    get new_item_url
    assert_response :success
  end

  test "index is reachable without login" do
    get items_url
    assert_response :success
  end
end
