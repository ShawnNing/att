require 'test_helper'

class SlipsControllerTest < ActionController::TestCase
  setup do
    @store = FactoryGirl.create(:store)
    cookies[:current_store] = @store.name
    @slip = FactoryGirl.create(:slip)
    @payroll = @slip.payroll
  end

  test "should get index" do
    get :index, payroll_id: @payroll
    assert_response :success
    assert_not_nil assigns(:slips)
  end

  test "should get new" do
    get :new, payroll_id: @payroll
    assert_response :success
  end

  test "should create slip" do
    assert_difference('Slip.count') do
      post :create, slip: {notes: @slip.notes }, payroll_id: @payroll
    end

    assert_redirected_to payroll_slip_path(@payroll, assigns(:slip))
  end

  test "should show slip" do
    get :show, id: @slip, payroll_id: @payroll
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @slip, payroll_id: @payroll
    assert_response :success
  end

  test "should update slip" do
    patch :update, id: @slip, slip: { notes: @slip.notes }, payroll_id: @payroll
    assert_redirected_to payroll_slip_path(@payroll, assigns(:slip))
  end

  test "should destroy slip" do
    assert_difference('Slip.count', -1) do
      delete :destroy, id: @slip, payroll_id: @payroll
    end

    assert_redirected_to payroll_slips_path(@payroll)
  end
end
