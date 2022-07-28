require "test_helper"

class CreateArticleTest < ActionDispatch::IntegrationTest

  setup do
    @admin_user = User.create(username: 'Tester', email: 'test@test.com', password: 'password', admin: true)
    sign_in_us(@admin_user)
  end

  test 'get new article and create article' do
    get '/articles/new'
    assert_response :success
    assert_difference 'Article.count', 1 do
      post articles_path, params: { article: { title: 'tests-test', description: 'test test test', category_ids: [] } }
      assert_response :redirect
    end
    follow_redirect!
    assert_response :success
    assert_match 'Article was created successfully.', response.body
  end

  test 'get new article and reject invalid article submission' do
    get '/articles/new'
    assert_response :success
    assert_no_difference 'Article.count' do
      post articles_path, params: { article: { title: 'tests-test', description: ' ', category_ids: [] } }
    end
    assert_match 'errors', response.body
    assert_select 'div.alert'
    assert_select 'h4.alert-heading'
  end
end
