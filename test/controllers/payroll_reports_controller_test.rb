require 'test_helper'

class PayrollReportsControllerTest < ActionController::TestCase
  setup do
    @payroll_report = payroll_reports(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:payroll_reports)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create payroll_report" do
    assert_difference('PayrollReport.count') do
      post :create, payroll_report: {  }
    end

    assert_redirected_to payroll_report_path(assigns(:payroll_report))
  end

  test "should show payroll_report" do
    get :show, id: @payroll_report
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @payroll_report
    assert_response :success
  end

  test "should update payroll_report" do
    patch :update, id: @payroll_report, payroll_report: {  }
    assert_redirected_to payroll_report_path(assigns(:payroll_report))
  end

  test "should destroy payroll_report" do
    assert_difference('PayrollReport.count', -1) do
      delete :destroy, id: @payroll_report
    end

    assert_redirected_to payroll_reports_path
  end
end
