require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user_session" do
    # FIXME: How to assert difference? #count doesn't exist.
    #assert_difference('UserSession.count') do
      post :create, :user_session => { :username => 'test', :password => 'tttt' }
    #end

    assert_redirected_to root_url
  end

  test "should destroy user_session" do
    # FIXME: Uh, how should this be tested?? Model doesn't extend ActiveRecord::Base so can't use fixtures properly.
    #assert_difference('UserSession.count', -1) do
    #  delete :destroy, :id => user_sessions(:one).to_param
    #end
    #
    #assert_redirected_to user_sessions_path
  end
end
