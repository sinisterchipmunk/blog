require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:comments)
  end

  test "should not get new if not logged in" do
    get :new
    assert_redirected_to root_path
  end

  test "should not create comment if not logged in" do
    assert_difference('Comment.count', 0) do
      post :create, :comment => { }
    end

    assert_redirected_to root_path
    #assert_redirected_to comment_path(assigns(:comment))
  end

  test "should show comment" do
    get :show, :id => comments(:one).to_param
    assert_response :success
  end

  test "should not get edit if not logged in" do
    get :edit, :id => comments(:one).to_param
    assert_redirected_to root_path
  end

  test "should not update comment if not logged in" do
    put :update, :id => comments(:one).to_param, :comment => { }
    assert_redirected_to root_path
    #assert_redirected_to comment_path(assigns(:comment))
  end

  test "should not destroy comment if not logged in" do
    assert_difference('Comment.count', 0) do
      delete :destroy, :id => comments(:one).to_param
    end

    assert_redirected_to root_path
    #assert_redirected_to comments_path
  end
end
