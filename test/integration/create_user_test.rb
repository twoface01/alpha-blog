require 'test_helper'

class CreateUserTest < ActionDispatch::IntegrationTest
  setup do
    @valid_username = "alpha-blog-user"
    @valid_email = "alpha-blog-user@alpha-blog-site.com"
    @valid_password = "abc123"
    @invalid_username = "ab"
    @invalid_email = "abs.com"
    @invalid_password = ""
  end

  test "get signup form and create the user" do
    get "/signup"
    assert_response :success
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { username: @valid_username, email: @valid_email, 
                password: @valid_password } }
      assert_response :redirect
    end
    follow_redirect!
    assert_response :success
    assert_match "signed up successfully", response.body
  end
  
  test "get signup form and error on empty username" do
    get "/signup"
    assert_response :success
    assert_no_difference 'User.count' do
      post users_path, params: { user: { username: "", email: @valid_email,
                password: @valid_password } }
    end
    assert_match "errors", response.body
    assert_select 'div.alert'
    assert_select 'div.alert-danger'
  end
  
  test "get signup form and error on invalid username" do
    get "/signup"
    assert_response :success
    assert_no_difference 'User.count' do
      post users_path, params: { user: { username: @invalid_username, email: @valid_email,
                password: @valid_password } }
    end
    assert_match "errors", response.body
    assert_select 'div.alert'
    assert_select 'div.alert-danger'
  end
  
  test "get signup form and error on empty email address" do
    get "/signup"
    assert_response :success
    assert_no_difference 'User.count' do
      post users_path, params: { user: { username: @valid_username, email: "",
                password: @valid_password } }
    end
    assert_match "errors", response.body
    assert_select 'div.alert'
    assert_select 'div.alert-danger'
  end
  
  test "get signup form and error on invalid email address" do
    get "/signup"
    assert_response :success
    assert_no_difference 'User.count' do
      post users_path, params: { user: { username: @valid_username, email: @invalid_email,
                password: @valid_password } }
    end
    assert_match "errors", response.body
    assert_select 'div.alert'
    assert_select 'div.alert-danger'
  end
  
  test "get signup form and error on empty password" do
    get "/signup"
    assert_response :success
    assert_no_difference 'User.count' do
      post users_path, params: { user: { username: @valid_username, email: @valid_email,
                password: @invalid_password } }
    end
    assert_match "errors", response.body
    assert_select 'div.alert'
    assert_select 'div.alert-danger'
  end

end
