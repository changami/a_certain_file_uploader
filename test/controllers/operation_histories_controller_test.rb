require 'test_helper'

class OperationHistoriesControllerTest < ActionController::TestCase
  setup do
    @operation_history = operation_histories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:operation_histories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create operation_history" do
    assert_difference('OperationHistory.count') do
      post :create, operation_history: {  }
    end

    assert_redirected_to operation_history_path(assigns(:operation_history))
  end

  test "should show operation_history" do
    get :show, id: @operation_history
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @operation_history
    assert_response :success
  end

  test "should update operation_history" do
    patch :update, id: @operation_history, operation_history: {  }
    assert_redirected_to operation_history_path(assigns(:operation_history))
  end

  test "should destroy operation_history" do
    assert_difference('OperationHistory.count', -1) do
      delete :destroy, id: @operation_history
    end

    assert_redirected_to operation_histories_path
  end
end
