require 'test_helper'

class CreateArticleTest < ActionDispatch::IntegrationTest
  setup do
    @blog_user = User.create(username: "test-account", email: "test@test.net",
                              password: "mypass123", admin: false)
    @valid_title = "Test Blog Article"
    @valid_description = "This is a test blog article."
    @invalid_title = "aa"
    @invalid_description = "bb"
    @category = Category.create(name: "Test Category")
  end
  
  test "get new article form and redirect for not being logged in" do
    get "/articles/new"
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_match "must be logged in", response.body
    assert_select 'div.alert'
    assert_select 'div.alert-danger'
  end
  
  test "get new article form while logged in" do
    sign_in_as(@blog_user)
    get "/articles/new"
    assert_response :success
    assert_match "Create A New Article", response.body
  end
  
  test "get new article form and create the article without categories" do
    sign_in_as(@blog_user)
    get "/articles/new"
    assert_response :success
    assert_difference 'Article.count', 1 do
      post articles_path, params: { article: { title: @valid_title, 
                  description: @valid_description, user_id: @blog_user } }
      assert_response :redirect
    end
    follow_redirect!
    assert_response :success
    assert_match "Article was created successfully.", response.body
    assert_select 'div.alert-success'
  end
  
  test "get new article form and create the article with categories" do
    sign_in_as(@blog_user)
    get "/articles/new"
    assert_response :success
    assert_difference 'Article.count', 1 do
      assert_difference 'ArticleCategory.count', 1 do
        post articles_path, params: { article: { title: @valid_title, 
                  description: @valid_description, category_ids: [@category.id] } }
        assert_response :redirect
      end
    end
    follow_redirect!
    assert_response :success
    assert_match "Article was created successfully.", response.body
    assert_select 'div.alert-success'
  end
  
  test "get new article form and error on invalid title" do
    sign_in_as(@blog_user)
    get "/articles/new"
    assert_response :success
    assert_no_difference 'Article.count' do
      post articles_path, params: { article: { title: @invalid_title, 
                  description: @valid_description, user_id: @blog_user } }
    end
    assert_match "Title is too short", response.body
    assert_select 'div.alert'
    assert_select 'div.alert-danger'
  end
  
  test "get new article form and error on invalid description" do
    sign_in_as(@blog_user)
    get "/articles/new"
    assert_response :success
    assert_no_difference 'Article.count' do
      post articles_path, params: { article: { title: @valid_title, 
                  description: @invalid_description, user_id: @blog_user } }
    end
    assert_match "Description is too short", response.body
    assert_select 'div.alert'
    assert_select 'div.alert-danger'
  end
  
end
