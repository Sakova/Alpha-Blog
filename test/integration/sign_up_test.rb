require 'test_helper'

class SignUpTest < ActionDispatch::IntegrationTest

  test 'sign up new user' do
    get '/signup'
    assert_response :success
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { username: 'test', email: 'test@test.com', password: 'password' } }
      assert_response :redirect
    end
    follow_redirect!
    assert_response :success
    assert_match 'Welcome to the Alpha Blog', response.body
  end

  test 'get new user and reject invalid user submission' do
    get '/signup'
    assert_response :success
    assert_no_difference 'User.count' do
      post users_path, params: { user: { username: 'test', email: ' ', password: 'password' } }
    end
    assert_match 'errors', response.body
    assert_select 'div.alert'
    assert_select 'h4.alert-heading'
  end
end
