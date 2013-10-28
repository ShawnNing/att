require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  setup do
    @store = FactoryGirl.create(:store)
    cookies[:current_store] = @store.name
    @comment = FactoryGirl.create(:comment)
    @post = @comment.post
  end

  test "should get index" do
    get :index, post_id: @post
    assert_response :success
    assert_not_nil assigns(:comments)
  end

  test "should get new" do
    get :new, post_id: @post
    assert_response :success
  end

  test "should create comment" do
    assert_difference('@post.comments.count') do
      post :create, comment: {body: @comment.body}, post_id: @post
      @post.reload #required because mongoid cache the count for embeded document
    end

    assert_redirected_to post_comment_path(@post, assigns(:comment))
  end

  test "should show comment" do
    get :show, id: @comment, post_id: @post
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @comment, post_id: @post
    assert_response :success
  end

  test "should update comment" do
    patch :update, id: @comment, comment: { body: @comment.body }, post_id: @post
    assert_redirected_to post_comment_path(@post, assigns(:comment))
  end

  test "should destroy comment" do
    assert_difference('@post.comments.count', -1) do
      delete :destroy, id: @comment, post_id: @post
      @post.reload #required because mongoid cache the count for embeded document
    end

    assert_redirected_to post_comments_path(@post)
  end
end
