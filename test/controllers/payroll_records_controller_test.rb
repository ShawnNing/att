require 'test_helper'

class PayrollRecordsControllerTest < ActionController::TestCase
  setup do
    @payroll_record = payroll_records(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:payroll_records)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create payroll_record" do
    assert_difference('PayrollRecord.count') do
      post :create, payroll_record: {  }
    end

    assert_redirected_to payroll_record_path(assigns(:payroll_record))
  end

  test "should show payroll_record" do
    get :show, id: @payroll_record
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @payroll_record
    assert_response :success
  end

  test "should update payroll_record" do
    patch :update, id: @payroll_record, payroll_record: {  }
    assert_redirected_to payroll_record_path(assigns(:payroll_record))
  end

  test "should destroy payroll_record" do
    assert_difference('PayrollRecord.count', -1) do
      delete :destroy, id: @payroll_record
    end

    assert_redirected_to payroll_records_path
  end
end
