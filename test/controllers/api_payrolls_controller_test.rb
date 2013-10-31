require 'test_helper'

class ApiPayrollsControllerTest < ActionController::TestCase
  def display(params, filtered_params)
    puts "========================="
    puts params
    puts "-------------------------"
    puts filtered_params
    puts "-------------------------"
  end
  
  setup do
    @employee1 = FactoryGirl.create(:employee)
    @employee2 = FactoryGirl.create(:employee)
    
    @payroll = FactoryGirl.build(:payroll)    
  end

  test "should create payroll" do
    #create payroll
    params = ActionController::Parameters.new({"payroll"=>{:start_date=>@payroll.start_date, :end_date=>@payroll.start_date}})
    p = params.require(:payroll).permit(:start_date, :end_date)
    display(params, p)
    payroll = Payroll.create(p)
    assert_equal(payroll.start_date, @payroll.start_date)
    assert_equal(payroll.slips.count, 0)

    #create slips
    params = ActionController::Parameters.new({:payroll=>{:start_date=>@payroll.start_date+1.day, :slips_attributes=>[{:notes=>'notes1', :employee_id=>@employee1.id.to_s}]}})
    p = params.require(:payroll).permit(:start_date, :slips_attributes=>[:id, :notes, :employee_id])
    display(params, p)
    payroll.update(p)
    assert_equal(payroll.start_date, @payroll.start_date+1.day)
    assert_equal(payroll.slips.count, 1)
    
    slip1 = payroll.slips.where({:employee_id=>@employee1.id.to_s}).first
  
    #update slip1, create slip2
    params = ActionController::Parameters.new({:payroll=>{:start_date=>@payroll.start_date+2.day, :slips_attributes=>[{:id=>slip1.id.to_s, :notes=>'notes11'}, {:notes=>'notes2', :employee_id=>@employee2.id.to_s}]}})
    p = params.require(:payroll).permit(:start_date, :slips_attributes=>[:id, :notes, :employee_id])
    display(params, p)
    payroll.update(p)
    slip1.reload
    assert_equal(payroll.start_date, @payroll.start_date+2.day)
    assert_equal(slip1.notes, 'notes11')
    assert_equal(payroll.slips.count, 2)

    #update slip1, create slip2
    params = ActionController::Parameters.new({:payroll=>{:slips_attributes=>[{:id=>slip1.id.to_s}]}})
    p = params.require(:payroll).permit(:start_date, :slips_attributes=>[:id, :notes, :employee_id])
    display(params, p)
    payroll.update(p)
    payroll.reload
    puts payroll.slips.count


  end

end
